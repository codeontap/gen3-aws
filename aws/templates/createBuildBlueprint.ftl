[#ftl]
[#include "setContext.ftl" ]

[#assign listMode = "buildblueprint"]
[#assign exceptionResources = []]
[#assign debugResources = []]

[#function getComponentBuildBlueprint ]
  [#local result={} ]

  [#list tiers as tier]

    [#list tier.Components!{} as id,component]
               
        [#if component?is_hash]
            [#list requiredOccurrences(
                getOccurrences(tier, component),
                deploymentUnit) as occurrence]
        
                [#local componentType = getComponentType(component)]

                [#local result += {
                    "Id" : id,
                    "Type" : componentType,
                    "Metadata" :
                        {
                            "Prepared" : .now?iso_utc,
                            "RequestReference" : requestReference,
                            "ConfigurationReference" : configurationReference,
                            "RunId" : runId
                        } +
                        attributeIfContent("CostCentre", accountObject.CostCentre!""),
                    "Occurrence" : occurrence
                    } +
                    valueIfContent(
                        {
                            "Debug" : debugResources
                        },
                        debugResources
                    ) +
                    valueIfContent(
                        {
                            "Exceptions" : exceptionResources
                        },
                        exceptionResources
                    )
                ]
            [/#list]
        [/#if]
    [/#list]
  [/#list]
  [#return result ]
[/#function]

[#if deploymentSubsetRequired("buildblueprint", true)]
    [@toJSON getComponentBuildBlueprint() /]
[/#if]
