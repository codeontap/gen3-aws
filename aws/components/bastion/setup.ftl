[#ftl]
[#macro aws_bastion_cf_deployment_generationcontract_segment occurrence ]
    [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro aws_bastion_cf_deployment_segment occurrence ]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = solution.Links ]

    [#local bastionRoleId = resources["role"].Id ]
    [#local bastionEIPId = resources["eip"].Id ]
    [#local bastionEIPName = resources["eip"].Name ]
    [#local bastionSecurityGroupToId = resources["securityGroupTo"].Id]
    [#local bastionSecurityGroupToName = resources["securityGroupTo"].Name]
    [#local bastionInstanceProfileId = resources["instanceProfile"].Id]
    [#local bastionAutoScaleGroupId = resources["autoScaleGroup"].Id]
    [#local bastionAutoScaleGroupName = resources["autoScaleGroup"].Name]
    [#local bastionLaunchConfigId = resources["launchConfig"].Id]
    [#local bastionLgId = resources["lg"].Id]
    [#local bastionLgName = resources["lg"].Name]
    [#local bastionOS = (solution.ComputeInstance.OperatingSystem.Family)!"linux"]

    [#local bastionASGTags = getOccurrenceCoreTags(
                        occurrence,
                        bastionAutoScaleGroupName
                        "",
                        true
                    )]

    [#local bastionType = occurrence.Core.Type]
    [#local configSetName = bastionType]

    [#local publicRouteTable = false ]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData", "AppData", "Encryption", "SSHKey" ] )]
    [#local baselineComponentIds = getBaselineComponentIds(baselineLinks)]
    [#local operationsBucket = getExistingReference(baselineComponentIds["OpsData"]) ]
    [#local dataBucket = getExistingReference(baselineComponentIds["AppData"])]
    [#local sshKeyPairId = baselineComponentIds["SSHKey"]!"HamletFatal: sshKeyPairId not found" ]

    [#if deploymentSubsetRequired("eip", false) || deploymentSubsetRequired("bastion", true) ]
        [#local occurrenceNetwork = getOccurrenceNetwork(occurrence) ]
        [#local networkLink = occurrenceNetwork.Link!{} ]
        [#local networkLinkTarget = getLinkTarget(occurrence, networkLink ) ]

        [#if ! networkLinkTarget?has_content ]
            [@fatal message="Network could not be found" context=networkLink /]
            [#return]
        [/#if]

        [#local networkConfiguration = networkLinkTarget.Configuration.Solution]
        [#local networkResources = networkLinkTarget.State.Resources ]

        [#local vpcId = networkResources["vpc"].Id ]

        [#local routeTableLinkTarget = getLinkTarget(occurrence, networkLink + { "RouteTable" : occurrenceNetwork.RouteTable }, false)]
        [#local routeTableConfiguration = routeTableLinkTarget.Configuration.Solution ]
        [#local publicRouteTable = routeTableConfiguration.Public ]
    [/#if]

    [#local storageProfile      = getStorage(occurrence, BASTION_COMPONENT_TYPE)]
    [#local logFileProfile      = getLogFileProfile(occurrence, BASTION_COMPONENT_TYPE)]
    [#local bootstrapProfile    = getBootstrapProfile(occurrence, BASTION_COMPONENT_TYPE)]
    [#local processorProfile    = getProcessor(occurrence, BASTION_COMPONENT_TYPE)]
    [#local networkProfile      = getNetworkProfile(occurrence)]
    [#local loggingProfile      = getLoggingProfile(occurrence)]

    [#local osPatching = mergeObjects(environmentObject.OSPatching, solution.ComputeInstance.OSPatching )]

    [#local sshActive = sshActive || solution.Active ]

    [#local processorProfile += {
                "MaxCount" : 2,
                "MinCount" : sshActive?then(1,0),
                "DesiredCount" : sshActive?then(1,0)
    }]

    [#if sshEnabled && publicRouteTable ]
        [#if deploymentSubsetRequired("eip", true) &&
                isPartOfCurrentDeploymentUnit(bastionEIPId)]
            [@createEIP
                id=bastionEIPId
                tags=getOccurrenceCoreTags(
                        occurrence,
                        bastionEIPName
                    )
            /]
        [/#if]
    [#else]
        [#local bastionEIPId = ""]
    [/#if]

    [#local contextLinks = getLinkTargets(occurrence, links) ]
    [#local _context =
        {
            "DefaultEnvironment" : defaultEnvironment(occurrence, contextLinks, baselineLinks),
            "Environment" : {},
            "Links" : contextLinks,
            "BaselineLinks" : baselineLinks,
            "DefaultCoreVariables" : true,
            "DefaultEnvironmentVariables" : true,
            "DefaultBaselineVariables" : true,
            "DefaultLinkVariables" : true,
            "Policy" : standardPolicies(occurrence, baselineComponentIds),
            "ManagedPolicy" : [],
            "ComputeTasks" : [],
            "Files" : {},
            "Directories" : {},
            "StorageProfile" : storageProfile,
            "LogFileProfile" : logFileProfile,
            "BootstrapProfile" : bootstrapProfile,
            "InstanceLogGroup" : bastionLgName,
            "InstanceOSPatching" : osPatching,
            "ElasticIPs" : asArray(bastionEIPId)
        }
    ]

    [#-- Add in extension specifics including override of defaults --]
    [#local _context = invokeExtensions( occurrence, _context )]
    [#local linkPolicies = getLinkTargetsOutboundRoles(_context.Links) ]

    [#local environmentVariables = getFinalEnvironment(occurrence, _context).Environment ]

    [#local componentComputeTasks = resources["autoScaleGroup"].ComputeTasks]
    [#local userComputeTasks = solution.ComputeInstance.ComputeTasks.UserTasksRequired ]
    [#local computeTaskExtensions = solution.ComputeInstance.ComputeTasks.Extensions ]

    [#local computeTaskConfig = getOccurrenceComputeTaskConfig(occurrence, bastionAutoScaleGroupId, _context, computeTaskExtensions, componentComputeTasks, userComputeTasks)]

    [#if sshEnabled ]

        [#list _context.Links as linkId,linkTarget]
            [#local linkTargetCore = linkTarget.Core ]
            [#local linkTargetConfiguration = linkTarget.Configuration ]
            [#local linkTargetResources = linkTarget.State.Resources ]
            [#local linkTargetAttributes = linkTarget.State.Attributes ]
            [#local linkTargetRoles = linkTarget.State.Roles]

            [#if deploymentSubsetRequired("bastion", true)]
                [@createSecurityGroupRulesFromLink
                    occurrence=occurrence
                    groupId=bastionSecurityGroupToId
                    linkTarget=linkTarget
                    inboundPorts=solution.ComputeInstance.ManagementPorts
                    networkProfile=networkProfile
                /]
            [/#if]
        [/#list]

        [#if deploymentSubsetRequired("iam", true) &&
                isPartOfCurrentDeploymentUnit(bastionRoleId)]
            [@createRole
                id=bastionRoleId
                trustedServices=["ec2.amazonaws.com" ]
                policies=
                    [
                        getPolicyDocument(
                            ec2AutoScaleGroupLifecyclePermission(bastionAutoScaleGroupName) +
                            ec2IPAddressUpdatePermission() +
                            ec2ReadTagsPermission() +
                            s3ListPermission(codeBucket) +
                            s3ReadPermission(codeBucket) +
                            s3AccountEncryptionReadPermission(
                                codeBucket,
                                "*",
                                codeBucketRegion
                            ) +
                            cwMetricsProducePermission("CWAgent") +
                            cwLogsProducePermission(bastionLgName),
                            "basic"
                        ),
                        getPolicyDocument(
                            ssmSessionManagerPermission(bastionOS),
                            "ssm"
                        )
                    ] +
                    arrayIfContent(
                        [getPolicyDocument(_context.Policy, "fragment")],
                        _context.Policy) +
                    arrayIfContent(
                        [getPolicyDocument(linkPolicies, "links")],
                        linkPolicies)
                managedArns=_context.ManagedPolicy
                tags=getOccurrenceCoreTags(occurrence)
            /]
        [/#if]


        [@setupLogGroup
            occurrence=occurrence
            logGroupId=bastionLgId
            logGroupName=bastionLgName
            loggingProfile=loggingProfile
        /]

        [#if deploymentSubsetRequired("bastion", true)]

            [#-- Create SSM Maintenance window --]
            [#local computeMaintenanceWindow = solution.ComputeInstance.MaintenanceWindow ]

            [#local windowId = resources["maintenanceWindow"].Id ]
            [#local windowName = resources["maintenanceWindow"].Name ]

            [#local windowTargetId = resources["maintenanceWindowTarget"].Id ]
            [#local windowTargetName = resources["maintenanceWindowTarget"].Name ]

            [#local patchingTaskId = resources["patchingMaintenanceTask"].Id ]
            [#local patchingTaskName = resources["patchingMaintenanceTask"].Name ]

            [#local maintenanceRoleId = resources["maintenanceRole"].Id ]

            [#local targetTags = bastionASGTags?filter( x-> ["Name", "cot:account", "cot:environment", "cot:product", "cot:segment" ]?seq_contains(x.Key))]

            [#-- Setup SSM Maintenance Window --]
            [@createSSMMaintenanceWindow
                id=windowId
                name=windowName
                schedule=getCronScheduleFromMaintenanceWindow(computeMaintenanceWindow)
                durationHours=1
                cutoffHours=0
                tags=getOccurrenceCoreTags(ocurrrence, windowName)
                scheduleTimezone=computeMaintenanceWindow.TimeZone
            /]

            [@createSSMMaintenanceWindowTarget
                id=windowTargetId
                name=windowTargetName
                windowId=windowId
                targets=getSSMWindowTargets(targetTags)
            /]

            [#-- Setup Patching --]
            [@createSSMMaintenanceWindowTask
                id=patchingTaskId
                name=patchingTaskName
                targets=[ {
                    "Key" : "WindowTargetIds",
                    "Values" : [ getReference(windowTargetId)]
                } ]
                windowId=windowId
                serviceRoleId=maintenanceRoleId
                taskId="AWS-RunPatchBaseline"
                taskType="RUN_COMMAND"
                taskParameters=getSSMWindowRunCommandTaskParameters(
                    "Install Security patch baseline",
                    {
                        "Operation" : [ "Install" ],
                        "RebootOption" : [ "RebootIfNeeded" ]
                    }
                )
            /]

            [@createRole
                id=maintenanceRoleId
                trustedServices=[
                    "ssm.amazonaws.com"
                ]
                policies=
                    [
                        getPolicyDocument(
                            [
                                getPolicyStatement(
                                    [
                                        "ssm:CancelCommand",
                                        "ssm:GetCommandInvocation",
                                        "ssm:ListCommandInvocations",
                                        "ssm:ListCommands",
                                        "ssm:SendCommand",
                                        "ssm:GetAutomationExecution",
                                        "ssm:GetParameters",
                                        "ssm:StartAutomationExecution",
                                        "ssm:ListTagsForResource",
                                        "ssm:GetCalendarState"
                                    ]
                                ),
                                getPolicyStatement(
                                    [
                                        "ssm:UpdateServiceSetting",
                                        "ssm:GetServiceSetting"
                                    ],
                                    [
                                        "arn:aws:ssm:*:*:servicesetting/ssm/opsitem/*",
                                        "arn:aws:ssm:*:*:servicesetting/ssm/opsdata/*"
                                    ]
                                )
                            ],
                            "basic"
                        )
                    ]
                tags=getOccurrenceCoreTags(occurrence)
            /]

            [@createSecurityGroup
                id=bastionSecurityGroupToId
                name=bastionSecurityGroupToName
                vpcId=vpcId
                description="Security Group for inbound SSH to the SSH Proxy"
                occurrence=occurrence
            /]

            [@createSecurityGroupRulesFromNetworkProfile
                occurrence=occurrence
                groupId=bastionSecurityGroupToId
                networkProfile=networkProfile
                inboundPorts=solution.ComputeInstance.ManagementPorts
            /]

            [#local bastionSSHNetworkRule = {
                        "Ports" : solution.ComputeInstance.ManagementPorts,
                        "IPAddressGroups" :
                            sshEnabled?then(
                                combineEntities(
                                    (segmentObject.Bastion.IPAddressGroups)!(segmentObject.IPAddressGroups)![],
                                    (solution.IPAddressGroups)![],
                                    UNIQUE_COMBINE_BEHAVIOUR
                                ),
                                []
                            ),
                        "Description" : "Bastion Access Groups"
            }]

            [@createSecurityGroupIngressFromNetworkRule
                occurrence=occurrence
                groupId=bastionSecurityGroupToId
                networkRule=bastionSSHNetworkRule
            /]

            [@cfResource
                id=bastionInstanceProfileId
                type="AWS::IAM::InstanceProfile"
                properties=
                    {
                        "Path" : "/",
                        "Roles" : [ getReference(bastionRoleId) ]
                    }
                outputs={}
            /]

            [@createEc2AutoScaleGroup
                id=bastionAutoScaleGroupId
                tier=core.Tier
                computeTaskConfig=computeTaskConfig
                launchConfigId=bastionLaunchConfigId
                processorProfile=processorProfile
                autoScalingConfig=solution.AutoScaling
                multiAZ=multiAZ
                tags=bastionASGTags
                networkResources=networkResources
            /]

            [@createEC2LaunchConfig
                id=bastionLaunchConfigId
                processorProfile=processorProfile
                storageProfile=_context.StorageProfile
                securityGroupId=bastionSecurityGroupToId
                instanceProfileId=bastionInstanceProfileId
                resourceId=bastionAutoScaleGroupId
                imageId=getEC2AMIImageId(solution.ComputeInstance.Image, bastionLaunchConfigId)
                publicIP=publicRouteTable
                computeTaskConfig=computeTaskConfig
                environmentId=environmentId
                sshFromProxy=[]
                keyPairId=sshKeyPairId
            /]
        [/#if]
    [/#if]
[/#macro]
