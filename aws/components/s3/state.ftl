[#ftl]

[#macro aws_s3_cf_state occurrence parent={} ]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local id = formatOccurrenceS3Id(occurrence)]
    [#local name = (formatOccurrenceBucketName(occurrence))?truncate_c(63, '') ]

    [#local publicAccessEnabled = false ]
    [#list solution.PublicAccess?values as publicPrefixConfiguration]
        [#if publicPrefixConfiguration.Enabled]
            [#local publicAccessEnabled = true ]
            [#break]
        [/#if]
    [/#list]

    [#local baselineLinks = getBaselineLinks(occurrence, [ "Encryption" ], true, false)]
    [#local baselineIds = getBaselineComponentIds(baselineLinks)]

    [#local s3AllEncryptionPolicy = []]
    [#local s3ReadEncryptionPolicy = []]
    [#if solution.Encryption.Enabled &&
        solution.Encryption.EncryptionSource == "EncryptionService" &&
        baselineIds?has_content]

        [#local s3AllEncryptionPolicy  = s3EncryptionAllPermission(
                baselineIds["Encryption"],
                name,
                "*",
                getExistingReference(id, REGION_ATTRIBUTE_TYPE)
            )]

        [#local s3ReadEncryptionPolicy  = s3EncryptionReadPermission(
                baselineIds["Encryption"],
                name,
                "*",
                getExistingReference(id, REGION_ATTRIBUTE_TYPE)
            )]
    [/#if]

    [#assign componentState =
        {
            "Resources" : {
                "bucket" : {
                    "Id" : id,
                    "Name" :
                        firstContent(
                            getExistingReference(id, NAME_ATTRIBUTE_TYPE),
                            name),
                    "Type" : AWS_S3_RESOURCE_TYPE
                },
                "role" : {
                    "Id" : formatResourceId( AWS_IAM_ROLE_RESOURCE_TYPE, core.Id ),
                    "Type" : AWS_IAM_ROLE_RESOURCE_TYPE,
                    "IncludeInDeploymentState" : false
                },
                "bucketpolicy" : {
                        "Id" : formatResourceId(AWS_S3_BUCKET_POLICY_RESOURCE_TYPE, core.Id),
                        "Type" : AWS_S3_BUCKET_POLICY_RESOURCE_TYPE
                }
            },
            "Attributes" : {
                "NAME" : getExistingReference(id, NAME_ATTRIBUTE_TYPE),
                "FQDN" : getExistingReference(id, DNS_ATTRIBUTE_TYPE),
                "INTERNAL_FQDN" : getExistingReference(id, DNS_ATTRIBUTE_TYPE),
                "WEBSITE_URL" : getExistingReference(id, URL_ATTRIBUTE_TYPE),
                "ARN" : getExistingReference(id, ARN_ATTRIBUTE_TYPE),
                "REGION" : getExistingReference(id, REGION_ATTRIBUTE_TYPE)
            },
            "Roles" : {
                "Inbound" : {
                    "invoke" : {
                        "Principal" : "s3.amazonaws.com",
                        "SourceArn" : getReference(id, ARN_ATTRIBUTE_TYPE)
                    }
                },
                "Outbound" : {
                    "all" : s3AllPermission(id) + s3AllEncryptionPolicy,
                    "produce" : s3ProducePermission(id) + s3AllEncryptionPolicy,
                    "consume" : s3ConsumePermission(id) + s3ReadEncryptionPolicy,
                    "replicadestination" : s3ReplicaDestinationPermission(id) + s3AllEncryptionPolicy,
                    "replicasource" : {},
                    "datafeed" : s3KinesesStreamPermission(id) + s3AllEncryptionPolicy
            }
            }
        }
    ]
[/#macro]
