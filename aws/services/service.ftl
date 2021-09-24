[#ftl]

[#-- Services --]
[#assign AWS_AMAZONMQ_SERVICE = "amazonmq" ]
[@addService provider=AWS_PROVIDER service=AWS_AMAZONMQ_SERVICE /]

[#assign AWS_APIGATEWAY_SERVICE = "apigateway"]
[@addService provider=AWS_PROVIDER service=AWS_APIGATEWAY_SERVICE /]

[#assign AWS_ATHENA_SERVICE = "athena"]
[@addService provider=AWS_PROVIDER service=AWS_ATHENA_SERVICE /]

[#assign AWS_CERTIFICATE_MANAGER_SERVICE = "acm"]
[@addService provider=AWS_PROVIDER service=AWS_CERTIFICATE_MANAGER_SERVICE /]

[#assign AWS_CLOUDFRONT_SERVICE = "cf"]
[@addService provider=AWS_PROVIDER service=AWS_CLOUDFRONT_SERVICE /]

[#assign AWS_CLOUDFORMATION_SERVICE = "cfn" ]
[@addService provider=AWS_PROVIDER service=AWS_CLOUDFORMATION_SERVICE /]

[#assign AWS_CLOUDMAP_SERVICE = "cloudmap"]
[@addService provider=AWS_PROVIDER service=AWS_CLOUDMAP_SERVICE /]

[#assign AWS_CLOUDWATCH_SERVICE = "cw"]
[@addService provider=AWS_PROVIDER service=AWS_CLOUDWATCH_SERVICE /]

[#assign AWS_COGNITO_SERVICE = "cognito"]
[@addService provider=AWS_PROVIDER service=AWS_COGNITO_SERVICE /]

[#assign AWS_DATA_PIPELINE_SERVICE = "datapipeline"]
[@addService provider=AWS_PROVIDER service=AWS_DATA_PIPELINE_SERVICE /]

[#assign AWS_DIRECTORY_SERVICE = "ds"]
[@addService provider=AWS_PROVIDER service=AWS_DIRECTORY_SERVICE /]

[#assign AWS_DYNAMODB_SERVICE = "dynamodb"]
[@addService provider=AWS_PROVIDER service=AWS_DYNAMODB_SERVICE /]

[#assign AWS_ELASTICACHE_SERVICE = "cache"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTICACHE_SERVICE /]

[#assign AWS_ELASTICSEARCH_SERVICE = "es"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTICSEARCH_SERVICE /]

[#assign AWS_ELASTIC_COMPUTE_SERVICE = "ec2"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTIC_COMPUTE_SERVICE /]

[#assign AWS_ELASTIC_CONTAINER_SERVICE = "ecs"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTIC_CONTAINER_SERVICE /]

[#assign AWS_ELASTIC_FILE_SYSTEM_SERVICE = "efs"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTIC_FILE_SYSTEM_SERVICE /]

[#assign AWS_ELASTIC_LOAD_BALANCER_SERVICE = "lb"]
[@addService provider=AWS_PROVIDER service=AWS_ELASTIC_LOAD_BALANCER_SERVICE /]

[#assign AWS_TRANSFER_SERVICE = "transfer" ]
[@addService provider=AWS_PROVIDER service=AWS_TRANSFER_SERVICE /]

[#assign AWS_IDENTITY_SERVICE = "iam"]
[@addService provider=AWS_PROVIDER service=AWS_IDENTITY_SERVICE /]

[#assign AWS_KEY_MANAGEMENT_SERVICE = "kms"]
[@addService provider=AWS_PROVIDER service=AWS_KEY_MANAGEMENT_SERVICE /]

[#assign AWS_KINESIS_SERVICE = "kinesis"]
[@addService provider=AWS_PROVIDER service=AWS_KINESIS_SERVICE /]

[#assign AWS_LAMBDA_SERVICE = "lambda"]
[@addService provider=AWS_PROVIDER service=AWS_LAMBDA_SERVICE /]

[#assign AWS_NETWORK_FIREWALL_SERVICE = "networkfirewall"]
[@addService provider=AWS_PROVIDER  service=AWS_NETWORK_FIREWALL_SERVICE /]

[#assign AWS_ORGANIZATIONS_SERVICE = "organizations"]
[@addService provider=AWS_PROVIDER  service=AWS_ORGANIZATIONS_SERVICE /]

[#assign AWS_PINPOINT_SERVICE = "pinpoint"]
[@addService provider=AWS_PROVIDER  service=AWS_PINPOINT_SERVICE /]

[#assign AWS_RELATIONAL_DATABASE_SERVICE = "rds"]
[@addService provider=AWS_PROVIDER service=AWS_RELATIONAL_DATABASE_SERVICE /]

[#assign AWS_RESOURCE_ACCESS_SERVICE = "resourceaccess" ]
[@addService provider=AWS_PROVIDER service=AWS_RESOURCE_ACCESS_SERVICE /]

[#assign AWS_ROUTE53_SERVICE = "route53"]
[@addService provider=AWS_PROVIDER service=AWS_ROUTE53_SERVICE /]

[#assign AWS_ROUTE53RESOLVER_SERVICE = "route53resolver"]
[@addService provider=AWS_PROVIDER service=AWS_ROUTE53RESOLVER_SERVICE /]

[#assign AWS_SECRETS_MANAGER_SERVICE = "secretsmanager" ]
[@addService provider=AWS_PROVIDER service=AWS_SECRETS_MANAGER_SERVICE /]

[#assign AWS_SIMPLE_STORAGE_SERVICE = "s3"]
[@addService provider=AWS_PROVIDER service=AWS_SIMPLE_STORAGE_SERVICE /]

[#assign AWS_SIMPLE_EMAIL_SERVICE = "ses"]
[@addService provider=AWS_PROVIDER service=AWS_SIMPLE_EMAIL_SERVICE /]

[#assign AWS_SIMPLE_NOTIFICATION_SERVICE = "sns"]
[@addService provider=AWS_PROVIDER service=AWS_SIMPLE_NOTIFICATION_SERVICE /]

[#assign AWS_SIMPLE_QUEUEING_SERVICE = "sqs"]
[@addService provider=AWS_PROVIDER service=AWS_SIMPLE_QUEUEING_SERVICE /]

[#assign AWS_SYSTEMS_MANAGER_SERVICE = "ssm"]
[@addService provider=AWS_PROVIDER service=AWS_SYSTEMS_MANAGER_SERVICE /]

[#assign AWS_TRANSIT_GATEWAY_SERVICE = "transitgateway" ]
[@addService provider=AWS_PROVIDER service=AWS_TRANSIT_GATEWAY_SERVICE /]

[#assign AWS_VPN_GATEWAY_SERVICE = "vpngateway" ]
[@addService provider=AWS_PROVIDER service=AWS_VPN_GATEWAY_SERVICE /]

[#assign AWS_VIRTUAL_PRIVATE_CLOUD_SERVICE = "vpc"]
[@addService provider=AWS_PROVIDER service=AWS_VIRTUAL_PRIVATE_CLOUD_SERVICE /]

[#assign AWS_WEB_APPLICATION_FIREWALL_SERVICE = "waf"]
[@addService provider=AWS_PROVIDER service=AWS_WEB_APPLICATION_FIREWALL_SERVICE /]

[#assign AWS_AUTOSCALING_SERVICE="autoscaling"]
[@addService provider=AWS_PROVIDER service=AWS_AUTOSCALING_SERVICE /]

[#-- Pseudo services --]
[#assign AWS_BASELINE_PSEUDO_SERVICE = "baseline"]
[@addService provider=AWS_PROVIDER service=AWS_BASELINE_PSEUDO_SERVICE /]
