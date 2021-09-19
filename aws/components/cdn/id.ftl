[#ftl]
[@addResourceGroupInformation
    type=CDN_COMPONENT_TYPE
    attributes=[]
    provider=AWS_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AWS_CLOUDFRONT_SERVICE,
            AWS_WEB_APPLICATION_FIREWALL_SERVICE,
            AWS_BASELINE_PSEUDO_SERVICE,
            AWS_CERTIFICATE_MANAGER_SERVICE,
            AWS_ROUTE53_SERVICE,
            AWS_KINESIS_SERVICE,
            AWS_CLOUDWATCH_SERVICE,
            AWS_IDENTITY_SERVICE
        ]
[#--

Comment out for now to avoid errors when no locations are configured.

    locations={
        DEFAULT_RESOURCE_GROUP : {
            "TargetComponentTypes" : [
                HOSTING_PLATFORM_COMPONENT_TYPE
            ]
        }
    }
--]
/]

[#-- @addResourceGroupInformation
    type=CDN_COMPONENT_TYPE
    attributes=[]
    provider=AWS_PROVIDER
    resourceGroup=DNS_RESOURCE_GROUP
    services=
        [
            AWS_ROUTE53_SERVICE
        ]
    locations={
        DNS_RESOURCE_GROUP : {
            "TargetComponentTypes" : [
                DNS_ZONE_COMPONENT_TYPE
            ]
        }
    }
/--]