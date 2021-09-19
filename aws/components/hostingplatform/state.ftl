[#ftl]

[#macro aws_hostingplatform_cf_state occurrence parent={} ]
    [#local core = getOccurrenceCore(occurrence) ]
    [#local solution = getOccurrenceSolution(occurrence) ]
    [#local locations = getOccurrenceLocations(occurrence) ]

    [#-- Combine any placement attributes with explicitly provided values --]
    [#local attributes =
        ((locations[DEFAULT_RESOURCE_GROUP].Attributes)!{}) +
        attributeIfContent(
            "REGION",
            (solution["Engine:region"].Region)!""
        )
    ]

    [#assign componentState =
        {
            "Resources" : {
                "external" : {
                    "Id" : formatResourceId("external", core.Id),
                    "Type" : "external",
                    "Deployed" :
                        attributes["PROVIDER"]?has_content &&
                        attributes["ACCOUNT"]?has_content &&
                        attributes["REGION"]?has_content
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
