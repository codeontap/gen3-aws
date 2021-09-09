[#ftl]

[#-- Resources --]
[#assign AWS_SSM_DOCUMENT_RESOURCE_TYPE = "ssmDocument"]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SYSTEMS_MANAGER_SERVICE
    resource=AWS_SSM_DOCUMENT_RESOURCE_TYPE
/]

[#assign AWS_SSM_MAINTENANCE_WINDOW_RESOURCE_TYPE = "ssmMaintenanceWindow" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SYSTEMS_MANAGER_SERVICE
    resource=AWS_SSM_MAINTENANCE_WINDOW_RESOURCE_TYPE
/]

[#assign AWS_SSM_MAINTENANCE_WINDOW_TARGET_RESOURCE_TYPE = "ssmWindowTarget" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SYSTEMS_MANAGER_SERVICE
    resource=AWS_SSM_MAINTENANCE_WINDOW_TARGET_RESOURCE_TYPE
/]

[#assign AWS_SSM_MAINTENANCE_WINDOW_TASK_RESOURCE_TYPE = "ssmWindowTask" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SYSTEMS_MANAGER_SERVICE
    resource=AWS_SSM_MAINTENANCE_WINDOW_TASK_RESOURCE_TYPE
/]

[#assign AWS_SSM_PATCH_BASELINE_RESOURCE_TYPE = "ssmPatchBaseline"]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SYSTEMS_MANAGER_SERVICE
    resource=AWS_SSM_PATCH_BASELINE_RESOURCE_TYPE
/]


[#-- Account level Session Manager Resources which are used by other components --]
[#function formatAccountSSMSessionManagerDocumentId ]
    [#return formatAccountResourceId(AWS_SSM_DOCUMENT_RESOURCE_TYPE, "console")]
[/#function]

[#function formatAccountSSMSessionManagerLogBucketId ]
    [#return formatAccountS3Id("console")]
[/#function]

[#function formatAccountSSMSessionManagerLogGroupId ]
    [#return migrateToResourceId(
        formatAccountResourceId(AWS_CLOUDWATCH_LOG_GROUP_RESOURCE_TYPE, "console"),
        [
            formatLogGroupId( "console" )
        ]
    )]
[/#function]

[#function formatAccountSSMSessionManagerKMSKeyId ]
    [#return formatAccountResourceId(AWS_CMK_RESOURCE_TYPE, "ssm" ) ]
[/#function]

[#function getAccountSSMSessionManagerKMSKeyId ]
    [#if (accountObject.Console.Encryption.DedicatedKey)!false ||
            getExistingReference(formatAccountSSMSessionManagerKMSKeyId)?has_content ]
        [#return formatAccountSSMSessionManagerKMSKeyId() ]
    [#else]
        [#return formatAccountCMKTemplateId() ]
    [/#if]
[/#function]
