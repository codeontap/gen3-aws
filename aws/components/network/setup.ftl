[#ftl]
[#macro aws_network_cf_deployment_generationcontract_segment occurrence ]
    [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro aws_network_cf_deployment_segment occurrence ]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]

    [#local vpcId = resources["vpc"].Id]
    [#local vpcResourceId = resources["vpc"].ResourceId]
    [#local vpcName = resources["vpc"].Name]
    [#local vpcCIDR = resources["vpc"].Address]

    [#local dnsSupport = (network.DNSSupport)!solution.DNS.UseProvider ]
    [#local dnsHostnames = (network.DNSHostnames)!solution.DNS.GenerateHostNames ]

    [#local loggingProfile = getLoggingProfile(solution.Profiles.Logging)]

    [#list resources["flowLogs"]!{} as  id, flowLogResource ]
        [#local flowLogId = flowLogResource["flowLog"].Id ]
        [#local flowLogName = flowLogResource["flowLog"].Name ]

        [#local flowLogRoleId = (flowLogResource["flowLogRole"].Id)!"" ]
        [#local flowLogLogGroupId = (flowLogResource["flowLogLg"].Id)!"" ]
        [#local flowLogLogGroupName = (flowLogResource["flowLogLg"].Name)!"" ]

        [#local flowLogSolution = solution.Logging.FlowLogs[id] ]
        [#local flowLogDestinationType = flowLogSolution.DestinationType ]

        [#local flowLogS3DestinationArn = "" ]
        [#local flowLogS3DestinationPrefix =
                    formatRelativePath(
                        flowLogSolution.s3.Prefix,
                        core.FullAbsolutePath,
                        id
                    )]

        [#if flowLogDestinationType == "log" ]
            [#if deploymentSubsetRequired("iam", true) &&
                    isPartOfCurrentDeploymentUnit(flowLogRoleId)]
                [@createRole
                    id=flowLogRoleId
                    trustedServices=["vpc-flow-logs.amazonaws.com"]
                    policies=
                        [
                            getPolicyDocument(
                                cwLogsProducePermission(flowLogLogGroupName),
                                "flow-logs-cloudwatch")
                        ]
                /]
            [/#if]

            [@setupLogGroup
                occurrence=occurrence
                logGroupId=flowLogLogGroupId
                logGroupName=flowLogLogGroupName
                loggingProfile=loggingProfile
                retention=((segmentObject.Operations.FlowLogs.Expiration) !
                                (segmentObject.Operations.Expiration) !
                                (environmentObject.Operations.FlowLogs.Expiration) !
                                (environmentObject.Operations.Expiration) ! 7)
            /]
        [/#if]

        [#if flowLogDestinationType = "s3" ]
            [#local destinationLink = getLinkTarget(occurrence, flowLogSolution.s3.Link) ]

            [#if destinationLink?has_content ]
                [#switch destinationLink.Core.Type ]
                    [#case S3_COMPONENT_TYPE]
                    [#case BASELINE_DATA_COMPONENT_TYPE]
                        [#local flowLogS3DestinationArn = (destinationLink.State.Attributes["ARN"])!"" ]
                        [#break]

                    [#default]
                        [@fatal
                            message="Invalid S3 Flow log destination component type"
                            context={
                                "Id" : flowLogsId,
                                "Link" : flowLogSolution.s3.Link
                            }
                        /]
                [/#switch]
            [/#if]
        [/#if]

        [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
            [@createFlowLog
                id=flowLogId
                logDestinationType=flowLogSolution.DestinationType
                resourceId=vpcResourceId
                resourceType="VPC"
                roleId=flowLogRoleId
                logGroupName=flowLogLogGroupName
                s3BucketId=flowLogS3DestinationArn
                s3BucketPrefix=flowLogS3DestinationPrefix
                trafficType=flowLogSolution.Action
                tags=getOccurrenceCoreTags(
                        occurrence,
                        formatName(core.FullName, "flowLog", id)
                    )
            /]
        [/#if]
    [/#list]

    [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
        [@createVPC
            id=vpcId
            resourceId=vpcResourceId
            name=vpcName
            cidr=vpcCIDR
            dnsSupport=dnsSupport
            dnsHostnames=dnsHostnames
        /]
    [/#if]

    [#local legacyIGWId = "" ]
    [#if (resources["legacyIGW"]!{})?has_content]
        [#local legacyIGWId = resources["legacyIGW"].Id ]
        [#local legacyIGWResourceId = resources["legacyIGW"].ResourceId]
        [#local legacyIGWName = resources["legacyIGW"].Name]
        [#local legacyIGWAttachmentId = resources["legacyIGWAttachment"].Id ]

        [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
            [@createIGW
                id=legacyIGWId
                resourceId=legacyIGWResourceId
                name=legacyIGWName
            /]
            [@createIGWAttachment
                id=legacyIGWAttachmentId
                vpcId=vpcResourceId
                igwId=legacyIGWResourceId
            /]
        [/#if]
    [/#if]

    [#if (resources["subnets"]!{})?has_content ]

        [#local subnetResources = resources["subnets"]]

        [#list subnetResources as tierId, zoneSubnets  ]

            [#local networkTier = getTier(tierId) ]
            [#local tierNetwork = getTierNetwork(tierId) ]

            [#local networkLink = tierNetwork.Link!{} ]
            [#local routeTableId = tierNetwork.RouteTable!"" ]
            [#local networkACLId = tierNetwork.NetworkACL!"" ]

            [#if !networkLink?has_content || !routeTableId?has_content || !networkACLId?has_content ]
                [@fatal
                    message="Tier Network configuration incomplete"
                    context=
                        tierNetwork +
                        {
                            "Link" : networkLink,
                            "RouteTable" : routeTableId,
                            "NetworkACL" : networkACLId
                        }
                /]

            [#else]

                [#local routeTable = getLinkTarget(occurrence, networkLink + { "RouteTable" : routeTableId }, false )]
                [#local routeTableZones = routeTable.State.Resources["routeTables"] ]

                [#local networkACL = getLinkTarget(occurrence, networkLink + { "NetworkACL" : networkACLId }, false )]
                [#local networkACLId = networkACL.State.Resources["networkACL"].Id ]

                [#local tierSubnetIdRefs = []]

                [#list zones as zone]

                    [#if zoneSubnets[zone.Id]?has_content]

                        [#local zoneSubnetResources = zoneSubnets[zone.Id]]
                        [#local subnetId = zoneSubnetResources["subnet"].Id ]
                        [#local subnetName = zoneSubnetResources["subnet"].Name ]
                        [#local subnetAddress = zoneSubnetResources["subnet"].Address ]
                        [#local routeTableAssociationId = zoneSubnetResources["routeTableAssoc"].Id]
                        [#local networkACLAssociationId = zoneSubnetResources["networkACLAssoc"].Id]
                        [#local routeTableId = (routeTableZones[zone.Id]["routeTable"]).Id]

                        [#local tierSubnetIdRefs += [ getReference(subnetId) ]]

                        [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
                            [@createSubnet
                                id=subnetId
                                name=subnetName
                                vpcId=vpcResourceId
                                tier=networkTier
                                zone=zone
                                cidr=subnetAddress
                                private=routeTable.Private!false
                            /]
                            [@createRouteTableAssociation
                                id=routeTableAssociationId
                                subnetId=subnetId
                                routeTableId=routeTableId
                            /]
                            [@createNetworkACLAssociation
                                id=networkACLAssociationId
                                subnetId=subnetId
                                networkACLId=networkACLId
                            /]
                        [/#if]
                    [/#if]
                [/#list]

                [#local tierListId = formatId( AWS_VPC_SUBNETLIST_TYPE, core.Id, tierId) ]
                [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
                    [@cfOutput
                            tierListId,
                            {
                                "Fn::Join": [
                                    ",",
                                    tierSubnetIdRefs
                                ]
                            },
                            true
                    /]
                [/#if]

            [/#if]
        [/#list]
    [/#if]

    [#list occurrence.Occurrences![] as subOccurrence]

        [@debug message="Suboccurrence" context=subOccurrence enabled=false /]

        [#local core = subOccurrence.Core ]
        [#local solution = subOccurrence.Configuration.Solution ]
        [#local resources = subOccurrence.State.Resources ]

        [#if !(solution.Enabled!false)]
            [#continue]
        [/#if]

        [#if core.Type == NETWORK_ROUTE_TABLE_COMPONENT_TYPE]

            [#local zoneRouteTables = resources["routeTables"] ]

            [#list zones as zone ]

                [#if zoneRouteTables[zone.Id]?has_content ]
                    [#local zoneRouteTableResources = zoneRouteTables[zone.Id] ]
                    [#local routeTableId = zoneRouteTableResources["routeTable"].Id]
                    [#local routeTableName = zoneRouteTableResources["routeTable"].Name]

                    [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
                        [@createRouteTable
                            id=routeTableId
                            name=routeTableName
                            vpcId=vpcResourceId
                            zone=zone
                        /]

                        [#if (zoneRouteTableResources["legacyIGWRoute"].Id!{})?has_content ]
                            [#local legacyIGWRouteId =  zoneRouteTableResources["legacyIGWRoute"].Id ]
                            [@createRoute
                                id=legacyIGWRouteId
                                routeTableId=routeTableId
                                destinationType="gateway"
                                destinationAttribute=getReference(legacyIGWResourceId)
                                destinationCidr="0.0.0.0/0"
                            /]
                        [/#if]

                    [/#if]
                [/#if]
            [/#list]
        [/#if]

        [#if core.Type == NETWORK_ACL_COMPONENT_TYPE ]

            [#local networkACLId = resources["networkACL"].Id]
            [#local networkACLName = resources["networkACL"].Name]

            [#local networkACLRules = resources["rules"]]

            [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]
                [@createNetworkACL
                    id=networkACLId
                    name=networkACLName
                    vpcId=vpcResourceId
                /]

                [#list networkACLRules as id, rule ]
                    [#local ruleId = rule.Id ]
                    [#local ruleConfig = solution.Rules[id] ]

                    [#if (ruleConfig.Source.IPAddressGroups)?seq_contains("_localnet")
                            && (ruleConfig.Source.IPAddressGroups)?size == 1 ]

                        [#local direction = "outbound" ]
                        [#local forwardIpAddresses = getGroupCIDRs(ruleConfig.Destination.IPAddressGroups, true, occurrence)]
                        [#local forwardPort = ports[ruleConfig.Destination.Port]]
                        [#local returnIpAddresses = getGroupCIDRs(ruleConfig.Destination.IPAddressGroups, true, occurrence)]
                        [#local returnPort = ports[ruleConfig.Source.Port]]

                    [#elseif (ruleConfig.Destination.IPAddressGroups)?seq_contains("_localnet")
                                && (ruleConfig.Source.IPAddressGroups)?size == 1 ]

                        [#local direction = "inbound" ]
                        [#local forwardIpAddresses = getGroupCIDRs(ruleConfig.Source.IPAddressGroups, true, occurrence)]
                        [#local forwardPort = ports[ruleConfig.Destination.Port]]
                        [#local returnIpAddresses = [ "0.0.0.0/0" ]]
                        [#local returnPort = ports[ruleConfig.Destination.Port]]

                    [#else]
                        [@fatal
                            message="Invalid network ACL either source or destination must be configured as _local to define direction"
                            context=port
                        /]
                    [/#if]

                    [#list forwardIpAddresses![] as ipAddress ]
                        [#local ruleOrder =  ruleConfig.Priority + ipAddress?index ]
                        [#local networkRule = {
                                "RuleNumber" : ruleOrder,
                                "Allow" : (ruleConfig.Action == "allow"),
                                "CIDRBlock" : ipAddress
                            }]
                        [@createNetworkACLEntry
                            id=formatId(ruleId,direction,ruleOrder)
                            networkACLId=networkACLId
                            outbound=(direction=="outbound")
                            rule=networkRule
                            port=forwardPort
                        /]
                    [/#list]

                    [#if ruleConfig.ReturnTraffic ]
                        [#local direction = (direction=="inbound")?then("outbound", "inbound")]

                        [#list returnIpAddresses![] as ipAddress ]
                            [#local ruleOrder = ruleConfig.Priority + ipAddress?index]

                            [#local networkRule = {
                                "RuleNumber" : ruleOrder,
                                "Allow" : (ruleConfig.Action == "allow"),
                                "CIDRBlock" : ipAddress
                                }]

                            [@createNetworkACLEntry
                                id=formatId(ruleId,direction,ruleOrder)
                                networkACLId=networkACLId
                                outbound=(direction=="outbound")
                                rule=networkRule
                                port=returnPort
                            /]
                        [/#list]
                    [/#if]
                [/#list]
            [/#if]
        [/#if]
    [/#list]
[/#macro]
