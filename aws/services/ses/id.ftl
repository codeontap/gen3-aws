[#ftl]

[#-- Resources --]
[#assign AWS_SES_RECEIPT_RULESET_RESOURCE_TYPE = "sesrecruleset" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SIMPLE_EMAIL_SERVICE
    resource=AWS_SES_RECEIPT_RULESET_RESOURCE_TYPE
/]

[#assign AWS_SES_RECEIPT_RULE_RESOURCE_TYPE = "sesrecrule" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SIMPLE_EMAIL_SERVICE
    resource=AWS_SES_RECEIPT_RULE_RESOURCE_TYPE
/]

[#assign AWS_SES_RECEIPT_FILTER_RESOURCE_TYPE = "sesrecfilter" ]
[@addServiceResource
    provider=AWS_PROVIDER
    service=AWS_SIMPLE_EMAIL_SERVICE
    resource=AWS_SES_RECEIPT_FILTER_RESOURCE_TYPE
/]

[#function formatSESReceiptRuleSetId ]
    [#return formatAccountResourceId(AWS_SES_RECEIPT_RULESET_RESOURCE_TYPE) ]
[/#function]

[#function formatSESReceiptRuleId extensions...]
    [#return formatResourceId(
                AWS_SES_RECEIPT_RULE_RESOURCE_TYPE,
                extensions)]
[/#function]

[#function formatSESReceiptFilterId extensions...]
    [#return formatAccountResourceId(
                AWS_SES_RECEIPT_FILTER_RESOURCE_TYPE,
                extensions)]
[/#function]