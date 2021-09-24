[#ftl]

[@addResourceGroupInformation
    type=DNS_ZONE_COMPONENT_TYPE
    attributes=[]
    provider=AWS_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AWS_ROUTE53_SERVICE
    ]
    locations={
        DEFAULT_RESOURCE_GROUP : {
            "TargetComponentTypes" : [
                SUBSCRIPTION_COMPONENT_TYPE
            ]
        }
    }
/]