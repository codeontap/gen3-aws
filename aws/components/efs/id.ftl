[#ftl]
[@addResourceGroupInformation
    type=EFS_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "IAMRequired",
            "Description" : "Require IAM Access to EFS",
            "Types" : BOOLEAN_TYPE,
            "Default" : false
        }
    ]
    provider=AWS_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AWS_ELASTIC_FILE_SYSTEM_SERVICE,
            AWS_VIRTUAL_PRIVATE_CLOUD_SERVICE
        ]
/]
