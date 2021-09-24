[#ftl]

[@addResourceGroupInformation
    type=SUBSCRIPTION_COMPONENT_TYPE
    attributes=[]
    provider=AWS_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AWS_ORGANIZATIONS_SERVICE
    ]
    locations={
        [#-- A link to a subscription is required if not importing the provider --]
        DEFAULT_RESOURCE_GROUP : {
            "Mandatory" : false,
            "TargetComponentTypes" : [
                SUBSCRIPTION_COMPONENT_TYPE
            ]
        }
    }
/]