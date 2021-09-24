[#ftl]

[#-- Resources --]
[#function formatDomainId ids...]
    [#return formatResourceId(
                "domain",
                ids)]
[/#function]

[#function formatSegmentDNSZoneId extensions...]
    [#return formatSegmentResourceId(
                "dnszone",
                extensions)]
[/#function]


[#assign AWS_ROUTE53_HEALTHCHECK_RESOURCE_TYPE = "route53HealthCheck" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_ROUTE53_SERVICE
    resource=AWS_ROUTE53_HEALTHCHECK_RESOURCE_TYPE
/]

[#assign AWS_ROUTE53_DNS_ZONE_RESOURCE_TYPE = "route53dnszone" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_ROUTE53_SERVICE
    resource=AWS_ROUTE53_DNS_ZONE_RESOURCE_TYPE
/]
