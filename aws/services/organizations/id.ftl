[#ftl]

[#-- Resources --]

[#assign AWS_ORGANIZATIONS_ACCOUNT_RESOURCE_TYPE = "account" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_ORGANIZATIONS_SERVICE
    resource=AWS_ORGANIZATIONS_ACCOUNT_RESOURCE_TYPE
/]
