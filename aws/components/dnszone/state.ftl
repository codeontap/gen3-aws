[#ftl]

[#macro aws_dnszone_cf_state occurrence parent={} ]
    [#local core = getOccurrenceCore(occurrence) ]
    [#local solution = getOccurrenceSolution(occurrence) ]
    [#local locations = getOccurrenceLocations(occurrence) ]

    [#-- Combine any placement attributes with explicitly provided values --]
    [#local attributes =
        {
            "REGION" : "us-east-1"
        } +
        ((locations[DEFAULT_RESOURCE_GROUP].Attributes)!{}) +
        attributeIfContent(
            "ZONE",
            solution["external:ProviderId"]!""
        )
    ]

    [#assign componentState =
        {
            "Resources" : {
                "external" : {
                    "Id" : formatResourceId(AWS_ROUTE53_DNS_ZONE_RESOURCE_TYPE, core.Id),
                    "Type" : AWS_ROUTE53_DNS_ZONE_RESOURCE_TYPE,
                    "Deployed" :
                        attributes["PROVIDER"]?has_content &&
                        attributes["ACCOUNT"]?has_content &&
                        attributes["ZONE"]?has_content
                }
            },
            "Attributes" : attributes,
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]
