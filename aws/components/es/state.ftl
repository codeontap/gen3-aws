[#ftl]

[#macro aws_es_cf_state occurrence parent={} ]
    [#local core = occurrence.Core]

    [#if core.External!false]
        [#local esId = occurrence.State.Attributes["ES_DOMAIN_ARN"]!"COTFatal: Could not find ARN" ]
        [#assign componentState =
            valueIfContent(
                {
                    "Resources" : {
                        "es" : {
                            "Id" : esId,
                            "Type" : AWS_ES_RESOURCE_TYPE,
                            "Deployed" : true
                        }
                    },
                    "Roles" : {
                        "Outbound" : {
                            "default" : "consume",
                            "consume" : esConsumePermission(esId),
                            "datafeed" : esKinesesStreamPermission(esId)
                        },
                        "Inbound" : {
                        }
                    }
                },
                esId,
                {}
            )
        ]

    [#else]

        [#local solution = occurrence.Configuration.Solution]
        [#local esId = formatResourceId(AWS_ES_RESOURCE_TYPE, core.Id)]
        [#local esHostName = getExistingReference(esId, DNS_ATTRIBUTE_TYPE) ]
        [#local esSnapshotRoleId = formatDependentRoleId(esId, "snapshotStore" ) ]

        [#local baselineLinks = getBaselineLinks(occurrence, [ "AppData" ] )]
        [#local baselineComponentIds = getBaselineComponentIds(baselineLinks)]

        [#local securityProfile = getSecurityProfile(solution.Profiles.Security, "es")]

        [#local securityGroupId = formatSecurityGroupId(core.Id)]
        [#local availablePorts = []]

        [#switch securityProfile.ProtocolPolicy!("COTFatal: Could not find Security profile - " + solution.Profiles.Security) ]
            [#case "https-only" ]
                [#local availablePorts += [ "https" ] ]
                [#break]

            [#case "http-https" ]
                [#local availablePorts += [ "http", "https" ]]
                [#break]

            [#case "http-only" ]
                [#local availablePorts += [ "http"]]
                [#break]
        [/#switch]

        [#assign componentState =
            {
                "Resources" : {
                    "es" : {
                        "Id" : esId,
                        "Name" : core.ShortFullName,
                        "Type" : AWS_ES_RESOURCE_TYPE,
                        "Monitored" : true
                    },
                    "servicerole" : {
                        "Id" : formatDependentRoleId(esId),
                        "Type" : AWS_IAM_ROLE_RESOURCE_TYPE,
                        "IncludeInDeploymentState" : false
                    },
                    "snapshotrole" : {
                        "Id" : esSnapshotRoleId,
                        "Type" : AWS_IAM_ROLE_RESOURCE_TYPE,
                        "IncludeInDeploymentState" : false
                    }
                } +
                attributeIfTrue(
                    "lg",
                    solution.Logging,
                    {
                        "Id" : formatLogGroupId(core.Id),
                        "Name" : core.FullAbsolutePath,
                        "Type" : AWS_CLOUDWATCH_LOG_GROUP_RESOURCE_TYPE,
                        "IncludeInDeploymentState" : false
                    }
                ) +
                attributeIfTrue(
                    "sg",
                    solution.VPCAccess,
                    {
                        "Id" : formatSecurityGroupId(core.Id),
                        "Ports" : availablePorts,
                        "Name" : core.FullName,
                        "Type" : AWS_VPC_SECURITY_GROUP_RESOURCE_TYPE
                    }
                ),
                "Attributes" : {
                    "REGION" : getExistingReference(esId, REGION_ATTRIBUTE_TYPE)!regionId,
                    "AUTH" : solution.Authentication,
                    "FQDN" : esHostName,
                    "URL" : "https://" + esHostName,
                    "KIBANA_URL" : "https://" + esHostName + "/_plugin/kibana/",
                    "PORT" : 443,
                    "SNAPSHOT_ROLE_ARN" : getExistingReference(esSnapshotRoleId, ARN_ATTRIBUTE_TYPE),
                    "SNAPSHOT_BUCKET" : getExistingReference(baselineComponentIds["AppData"]),
                    "SNAPSHOT_PATH" : getAppDataFilePrefix(occurrence)
                },
                "Roles" : {
                    "Outbound" : {
                        "default" : "consume",
                        "consume" : esConsumePermission(esId),
                        "datafeed" : esKinesesStreamPermission(esId),
                        "snapshot" : esConsumePermission(esId) +
                                        iamPassRolePermission(
                                            getExistingReference(esSnapshotRoleId, ARN_ATTRIBUTE_TYPE)
                                        )
                    } +
                    attributeIfTrue(
                        "networkacl",
                        solution.VPCAccess,
                        {
                            "Ports" : [ availablePorts ],
                            "SecurityGroups" : getExistingReference(securityGroupId),
                            "Description" : core.FullName
                        }
                    ),
                    "Inbound" : {
                    } +
                    attributeIfTrue(
                        "networkacl",
                        solution.VPCAccess,
                        {
                            "SecurityGroups" : getExistingReference(securityGroupId),
                            "Description" : core.FullName
                        }
                    )
                }
            }
        ]
    [/#if]
[/#macro]
