[#ftl]

[#assign AWS_SSM_DOCUMENT_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[@addOutputMapping
    provider=AWS_PROVIDER
    resourceType=AWS_SSM_DOCUMENT_RESOURCE_TYPE
    mappings=AWS_SSM_DOCUMENT_OUTPUT_MAPPINGS
/]

[#assign AWS_SSM_MAINTENANCE_WINDOW_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[@addOutputMapping
    provider=AWS_PROVIDER
    resourceType=AWS_SSM_MAINTENANCE_WINDOW_RESOURCE_TYPE
    mappings=AWS_SSM_MAINTENANCE_WINDOW_OUTPUT_MAPPINGS
/]

[#assign AWS_SSM_PATCH_BASELINE_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[@addOutputMapping
    provider=AWS_PROVIDER
    resourceType=AWS_SSM_PATCH_BASELINE_RESOURCE_TYPE
    mappings=AWS_SSM_PATCH_BASELINE_OUTPUT_MAPPINGS
/]

[#macro createSSMDocument id content tags name="" documentType="" dependencies="" ]
    [@cfResource
        id=id
        type="AWS::SSM::Document"
        properties=
            {
                "Content" : content,
                "DocumentType" : documentType,
                "Tags" : tags
            } +
            attributeIfContent(
                "Name",
                name
            )
        outputs=SSM_DOCUMENT_OUTPUT_MAPPINGS
        dependencies=dependencies
    /]
[/#macro]

[#macro createSSMMaintenanceWindow id
    name
    schedule
    durationHours
    cutoffHours
    tags=[]
    scheduleTimezone="Etc/UTC"
    dependencies=[]
]
    [@cfResource
        id=id
        type="AWS::SSM::MaintenanceWindow"
        properties=
            {
                "Name" : name,
                "AllowUnassociatedTargets" : false,
                "Schedule" : schedule,
                "Duration" : durationHours,
                "Cutoff" : cutoffHours,
                "ScheduleTimezone" : scheduleTimezone
            }
        tags=tags
        outputs=AWS_SSM_MAINTENANCE_WINDOW_OUTPUT_MAPPINGS
        dependencies=dependencies
    /]
[/#macro]

[#function getSSMWindowTargets tags=[] instanceIds=[] usePlaceholderInstance=false ]
    [#local targets = [] ]
    [#if usePlaceholderInstance ]
        [#local targets += [
            {
                "Key" : "InstanceIds",
                "Values" : asArray("i-00000000000000000")
            }
        ]]
    [#else]
        [#list tags as tag ]
            [#local targets += [
                {
                    "Key" : "tag:${tag.Key}",
                    "Values" : asArray(tag.Value)
                }
            ]]
        [/#list]

        [#if instanceIds?has_content ]
            [#local targets += [
                {
                    "Key" : "InstanceIds",
                    "Values" : asArray(instanceIds)
                }
            ]]
        [/#if]
    [/#if]
    [#return targets]
[/#function]

[#macro createSSMMaintenanceWindowTarget id
    name
    windowId
    targets
    dependencies=""
]
    [@cfResource
        id=id
        type="AWS::SSM::MaintenanceWindowTarget"
        properties=
            {
                "Name" : name,
                "OwnerInformation" : name,
                "WindowId" : getReference(windowId),
                "ResourceType" : "INSTANCE",
                "Targets" : targets
            }
        dependencies=dependencies
    /]
[/#macro]

[#function getSSMWindowAutomationTaskParameters parameters documentVersion="" ]
    [#return
        {
            "Parameters" : parameters
        } +
        attributeIfContent(
            "DocumentVersion",
            documentVersion
        )]
[/#function]

[#function getSSMWindowLambdaTaskParameters payload clientContext="" lambdaQualifer="" ]
    [#return
        {
            "Payload" : payload
        } +
        attributeIfContent(
            "Qualifier",
            lambdaQualifer
        ) +
        attributeIfContent(
            "ClientContext",
            clientContext
        )]
[/#function]

[#function getSSMWindowRunCommandTaskParameters description=""
                parameters={}
                documentHash=""
                topicId=""
                notificationRoleId=""
                notificationEvents=[]
                notificationType=""
                resultBucketId=""
                resultBucketPrefix=""
                timeout=300
                documentHashType="Sha256" ]
    [#return
        {
            "TimeoutSeconds" : timeout?number
        } +
        attributeIfContent(
            "Comment",
            description
        ) +
        attributeIfContent(
            "DocumentHash",
            documentHash
        ) +
        attributeIfTrue(
            "DocumentHashType",
            documentHash?has_content,
            documentHashType
        ) +
        attributeIfTrue(
            "NotificationConfig",
            notificationEvents?has_content,
            {
                "NotificationArn" : getArn(topicId),
                "NotificationEvents" : asArray(notificationEvents),
                "NotificationType" : notificationType
            }
        ) +
        attributeIfContent(
            "OutputS3BucketName",
            resultBucketId,
            getReference(resultBucketId, NAME_ATTRIBUTE_TYPE)
        ) +
        attributeIfContent(
            "OutputS3KeyPrefix",
            resultBucketPrefix
        ) +
        attributeIfContent(
            "Parameters",
            parameters
        ) +
        attributeIfTrue(
            "ServiceRoleArn",
            ( notificationEvents?has_content && notificationRoleId?has_content ),
            getArn(notificationRoleId)
        )
    ]
[/#function]

[#macro createSSMMaintenanceWindowTask id
    name
    targets
    windowId
    taskId
    taskType
    taskParameters={}
    serviceRoleId=""
    priority=10
    maxErrors=1
    maxConcurrency=1
    dependencies=""
]

    [#local taskType = taskType?upper_case ]

    [@cfResource
        id=id
        type="AWS::SSM::MaintenanceWindowTask"
        properties=
            {
                "Name" : name,
                "MaxErrors" : maxErrors?c,
                "WindowId" : getReference(windowId),
                "Priority" : priority,
                "MaxConcurrency" : maxConcurrency?c,
                "Targets" : targets,
                "TaskArn" : ( taskType == "AUTOMATION" || taskType == "RUN_COMMAND" )?then(
                                taskId,
                                getReference(taskId, ARN_ATTRIBUTE_TYPE)
                ),
                "TaskType" : taskType
            } +
            attributeIfContent(
                "TaskInvocationParameters",
                taskParameters,
                {} +
                (taskType == "AUTOMATION" )?then(
                    {
                        "MaintenanceWindowAutomationParameters" : taskParameters
                    },
                    {}
                ) +
                (taskType == "LAMBDA" )?then(
                    {
                        "MaintenanceWindowLambdaParameters" : taskParameters
                    },
                    {}
                ) +
                (taskType == "RUN_COMMAND")?then(
                    {
                        "MaintenanceWindowRunCommandParameters" : taskParameters
                    },
                    {}
                ) +
                (taskType == "STEP_FUNCTIONS")?then(
                    {
                        "MaintenanceWindowStepFunctionsParameters" : taskParameters
                    },
                    {}
                )
            ) +
            attributeIfContent(
                "ServiceRoleArn",
                serviceRoleId,
                getReference(serviceRoleId, ARN_ATTRIBUTE_TYPE)
            )
        dependencies=dependencies
    /]
[/#macro]

[#function getSSMPatchBaselinePatchSource name configuration products ]
    [#return
        {
            "Name" : name,
            "Configuration" : configuration,
            "Products" : asArray(products)
        }
    ]
[/#function]

[#function getSSMPatchBaselinePatchFilter key values=[] ]
    [#return
        {
            "Key" : key,
            "Values" : asArray(values)
        }
    ]
[/#function]

[#function getSSMPatchBaselinePatchRule
            operatingSystem
            approveAfterDays
            complianceLevel=""
            patchFilters=[]
            enableNonSecurity=false ]

    [#switch operatingSystem]
        [#case "debian"]
        [#case "ubuntu"]
            [#local approveAfterDays = ""]
            [#break]
        [#case "windows"]
            [#local enableNonSecurity = ""]
            [#break]
    [/#switch]

    [#return
        {} +
        attributeIfContent(
            "ApproveAfterDays",
            approveAfterDays,
            approveAfterDays?number
        ) +
        attributeIfContent(
            "ComplianceLevel",
            complianceLevel,
            complianceLevel?upper_case
        ) +
        attributeIfContent(
            "EnableNonSecurity",
            enableNonSecurity
        ) +
        attributeIfTrue(
            "PatchFilterGroup",
            ( patchFilters? has_content ),
            {} +
            attributeIfContent(
                "PatchFilters",
                patchFilters,
                asArray(patchFilters)
            )
        )
    ]
[/#function]

[#macro createSSMPatchBaseline id name
        description=""
        patchRules={}
        approvedPatches=[]
        approvedPatchComplianceLevel=""
        approveNonSecurityPatches=""
        globalFilters={}
        operatingSystem=""
        patchGroups=[]
        rejectedPatches=[]
        rejectedPatchesAction=""
        sources=[]
        tags=[]
        dependencies=[] ]

    [@cfResource
        id=id
        type="AWS::SSM::PatchBaseline"
        properties={
            "Name" : name
        } +
        attributeIfTrue(
            "ApprovalRules",
            (approvalRules?has_content),
            {} +
            attributeIfContent(
                "PatchRules",
                patchRules,
                asArray(patchRules)
            )
        ) +
        attributeIfContent(
            "ApprovedPatches",
            approvedPatches,
            asArray(approvedPatches)
        ) +
        attributeIfContent(
            "ApprovedPatchesComplianceLevel",
            approvedPatchComplianceLevel
        ) +
        attributeIfContent(
            "ApprovedPatchesEnableNonSecurity",
            approveNonSecurityPatches,
            approveNonSecurityPatches?boolean
        ) +
        attributeIfContent(
            "Description",
            description
        ) +
        attributeIfContent(
            "GlobalFilters",
            globalFilters
        ) +
        attributeIfContent(
            "OperatingSystem",
            operatingSystem
        ) +
        attributeIfContent(
            "PatchGroups",
            patchGroups,
            asArray(patchGroups)
        ) +
        attributeIfContent(
            "RejectedPatches",
            rejectedPatches,
            asArray(rejectedPatches)
        ) +
        attributeIfContent(
            "RejectedPatchesAction",
            rejectedPatchesAction,
            rejectedPatchesAction?upper_case
        ) +
        attributeIfContent(
            "Sources",
            sources
        )
        dependencies=dependencies
        tags=tags
    /]
[/#macro]

[#-- SSM Parameter Resolution in CFN Templates --]
[#-- Allows for Cloudformation to return parameter data from SSM Paramter Store --]

[#macro addCFNSSMStringParam id default="" description="" ]
    [@cfParameter
        id=id
        type="AWS::SSM::Parameter::Value<String>"
        default=default
        description=description
    /]
[/#macro]

[#macro addCFNSSMStringListParam id default="" description="" ]
    [@cfParameter
        id=id
        type="AWS::SSM::Parameter::Value<List<String>>"
        default=default
        description=description
    /]
[/#macro]

[#macro addCFNSSMCommaListParam id default="" description="" ]
    [@cfParameter
        id=id
        type="AWS::SSM::Parameter::Value<CommaDelimitedList>"
        default=default
        description=description
    /]
[/#macro]

[#macro addCFNSSMEC2ImageParam id default="" description="" ]
    [@cfParameter
        id=id
        type="AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>"
        default=default
        description=description
    /]
[/#macro]

[#-- Common setup resources --]
[#function getCronScheduleFromMaintenanceWindow maintenanceWindow ]

    [#local cronSections = {
        "minute" : maintenanceWindow.TimeOfDay?split(":")[1],
        "hour" : maintenanceWindow.TimeOfDay?split(":")[0],
        "dayMonth" : "?",
        "month" : "*",
        "dayWeek" : maintenanceWindow.DayOfTheWeek[0..2]?upper_case,
        "year" : "*"
    }]

    [#return "cron(" + cronSections?values?join(" ") + ")" ]
[/#function]

[#macro setupComputeInstancePatchWindow ocurrrence
        windowId
        windowName
        opsdataBucketName
        maintenanceWindow
        osPatching
        maxProcessorCount=1
        instanceUpdateTimeMinutes=30
        topicId="" ]

    [@createSSMMaintenanceWindow
        id=windowId
        name=windowName
        schedule=getCronScheduleFromMaintenanceWindow(maintenanceWindow)
        durationHours=(maxProcessorCount * instanceUpdateTimeMinutes) / 60
        tags=getOccurrenceCoreTags(ocurrrence, ocurrrence.Core.FullName)
        scheduleTimezone=maintenanceWindow.TimeZone
    /]

    [#-- Patch Window --]
    [@createSSMMaintenanceWindowTask
        id
        name
        targets
        serviceRoleId
        windowId
        taskId
        taskType
        taskParameters
        priority=10
        maxErrors=1
        maxConcurrency=1
        dependencies=""
    /]


[/#macro]
