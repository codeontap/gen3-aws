# Changelog

## latest (2025-02-10)

#### New Features

* add a default extension for cloudwatch alarm module
* WAFACLs to support IPV6
* waf service to support IPV6 CIDRs
* initial deployment contract support ([#800](https://github.com/hamlet-io/engine-plugin-aws/issues/800))
* support recommended token auth method for Pinpoint channels ([#805](https://github.com/hamlet-io/engine-plugin-aws/issues/805))
#### Fixes

* (waf): check if addresses is empty before testing for ip version
* add tagPatternList for tagged max count ECR lifecycle rule ([#813](https://github.com/hamlet-io/engine-plugin-aws/issues/813))
* (ecs): set security group for a scheduled task ([#812](https://github.com/hamlet-io/engine-plugin-aws/issues/812))
* add host to list of network modes
* update input regex for alb service logs table
* connectionTimeout attribute
* autoMinorVersionUpdate flag for Amazon MQ resource
* cdn origin request policy headers
#### Others

* update changelog ([#810](https://github.com/hamlet-io/engine-plugin-aws/issues/810))
* update changelog ([#804](https://github.com/hamlet-io/engine-plugin-aws/issues/804))
* pin cfn-lint for now to pass the tests and produce uncicyle

Full set of changes: [`9.1.0...latest`](https://github.com/hamlet-io/engine-plugin-aws/compare/9.1.0...latest)

## 9.1.0 (2024-03-27)

#### New Features

* (s3): batch replication support ([#801](https://github.com/hamlet-io/engine-plugin-aws/issues/801))
* (user): add permissions boundary arn config ([#799](https://github.com/hamlet-io/engine-plugin-aws/issues/799))
* add the cluster type when calling snapshot username ([#796](https://github.com/hamlet-io/engine-plugin-aws/issues/796))
* (baseline): add sqs extension ([#792](https://github.com/hamlet-io/engine-plugin-aws/issues/792))
* (db): add storage type configuration support ([#790](https://github.com/hamlet-io/engine-plugin-aws/issues/790))
* cdn aliases ([#789](https://github.com/hamlet-io/engine-plugin-aws/issues/789))
* instance type support for lb
* add support for kms replication of objects
* (topic): add fixed endpoint subscriptions ([#786](https://github.com/hamlet-io/engine-plugin-aws/issues/786))
* (waf): enable waf and add challenges ([#784](https://github.com/hamlet-io/engine-plugin-aws/issues/784))
* (user): name format handling
* (vpcendpoint): source vpc endpoint extension ([#777](https://github.com/hamlet-io/engine-plugin-aws/issues/777))
* (user): source IP filtering
* SQS and SNS endpoint policies ([#775](https://github.com/hamlet-io/engine-plugin-aws/issues/775))
* (ec2): lb fixed target mapping ([#774](https://github.com/hamlet-io/engine-plugin-aws/issues/774))
* (lb): client IP control ([#773](https://github.com/hamlet-io/engine-plugin-aws/issues/773))
* (iam): extend use of the large policy setup
* (vpcendpoint): policy support ([#764](https://github.com/hamlet-io/engine-plugin-aws/issues/764))
* (apigateway): private APIs ([#762](https://github.com/hamlet-io/engine-plugin-aws/issues/762))
* (mta): stop after match
#### Fixes

* changelog pipeline ([#803](https://github.com/hamlet-io/engine-plugin-aws/issues/803))
* (cdn): restrict CDN region check lookup ([#798](https://github.com/hamlet-io/engine-plugin-aws/issues/798))
* (ec2): update ssh key env lookup ([#797](https://github.com/hamlet-io/engine-plugin-aws/issues/797))
* (ecs): policy split for ecs tasks ([#795](https://github.com/hamlet-io/engine-plugin-aws/issues/795))
* target group sg lookup
* typo in templates
* (ecs): memory and lb complex configuration ([#794](https://github.com/hamlet-io/engine-plugin-aws/issues/794))
* (correspondent): only deploy for right template type ([#793](https://github.com/hamlet-io/engine-plugin-aws/issues/793))
* (topic): kms permissions ([#791](https://github.com/hamlet-io/engine-plugin-aws/issues/791))
* (firewall): add both log destinations for all
* (datafeed): support subset passes ([#782](https://github.com/hamlet-io/engine-plugin-aws/issues/782))
* (ecs): round max memory when calculated
* (gateway): route table collection
* add note for migration
* ec2 sec groups and ecs ids
* (gateway): duplicate route table ids ([#770](https://github.com/hamlet-io/engine-plugin-aws/issues/770))
* (gateway): duplicate route table ids ([#769](https://github.com/hamlet-io/engine-plugin-aws/issues/769))
* (account): disable cloudtrail by default
* (objectsql): permissions state details
* docker image tag extension ([#765](https://github.com/hamlet-io/engine-plugin-aws/issues/765))
* (cdn): extraneous resources in lg pass ([#761](https://github.com/hamlet-io/engine-plugin-aws/issues/761))
#### Refactorings

* (datafeed): check for undeployed lambda ([#781](https://github.com/hamlet-io/engine-plugin-aws/issues/781))
* (datafeed): undeployed lambda functions ([#778](https://github.com/hamlet-io/engine-plugin-aws/issues/778))
* remove use of component ids
#### Others

* update changelog ([#785](https://github.com/hamlet-io/engine-plugin-aws/issues/785))
* update actions pipelines ([#802](https://github.com/hamlet-io/engine-plugin-aws/issues/802))
* update changelog ([#760](https://github.com/hamlet-io/engine-plugin-aws/issues/760))
* (datapipeline): remove support for AWS data pipeline

Full set of changes: [`8.9.0...9.1.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.9.0...9.1.0)

## 8.9.0 (2023-06-16)

#### New Features

* (ecs): control if ec2 asg should be created
* (waf): label matching and vendor overrides
* (network): support default sg nacl control
* support for custom body block responses
* (waf): add support for regex pattern set
* (userpool): enable support for schema attr
* (ecs): task cpu, depends on, readonly
* add support for multiple paths on lb ([#729](https://github.com/hamlet-io/engine-plugin-aws/issues/729))
* (lb): add support for multi value in lb lambda ([#727](https://github.com/hamlet-io/engine-plugin-aws/issues/727))
* (mta): Add support for bounces on receive ([#724](https://github.com/hamlet-io/engine-plugin-aws/issues/724))
* (baseline): cmk access for cloudwatch service
* (cdn): include body for lambda@edge
* add support for allExcept on cachepolicy ([#721](https://github.com/hamlet-io/engine-plugin-aws/issues/721))
* (rds): add support for cloudwatch log export ([#719](https://github.com/hamlet-io/engine-plugin-aws/issues/719))
* (es): extend encrypotion config and custom endpoints ([#718](https://github.com/hamlet-io/engine-plugin-aws/issues/718))
* add smtp endpoint address to send mta ([#715](https://github.com/hamlet-io/engine-plugin-aws/issues/715))
* (sqs): add support for enabling SSE on sqs
* (module): add ses send events to service logs
* (module): add ses based mail sender with log ([#712](https://github.com/hamlet-io/engine-plugin-aws/issues/712))
* (baseline): add image reference update runbook
* (secretstore): add descriptions on secrets ([#703](https://github.com/hamlet-io/engine-plugin-aws/issues/703))
* (s3): add support for in-transit https policy
* remove the user defined boostrap process
* (ecr): extended repository configuration
* (ecs): add support for container insights
* (runbooks): shorter names and pull image
* (userpool): define email from address ([#696](https://github.com/hamlet-io/engine-plugin-aws/issues/696))
* (s3): add support for replication v2 ([#690](https://github.com/hamlet-io/engine-plugin-aws/issues/690))
* (userpool): control hosted ui setup ([#686](https://github.com/hamlet-io/engine-plugin-aws/issues/686))
* (cloudtrail): Add support for cloudtrail ([#687](https://github.com/hamlet-io/engine-plugin-aws/issues/687))
* (iam): add support for not actions on policies ([#688](https://github.com/hamlet-io/engine-plugin-aws/issues/688))
* oversize handling and method fieldtotest ([#685](https://github.com/hamlet-io/engine-plugin-aws/issues/685))
* (ecs): propagate service tags to tasks ([#682](https://github.com/hamlet-io/engine-plugin-aws/issues/682))
* (db): add support for RDS Proxies ([#678](https://github.com/hamlet-io/engine-plugin-aws/issues/678))
* (images): add support for images on components
* (image): Adds aws image component
#### Fixes

* (lb): handle the documented lb default priority ([#759](https://github.com/hamlet-io/engine-plugin-aws/issues/759))
* (baseline): permissions for logging
* (secretstore): handle missing cmk
* (api): build info sourcing ([#753](https://github.com/hamlet-io/engine-plugin-aws/issues/753))
* (s3): inbound link permissions for cdn
* (cdn): link to cachepolicy
* (api): image registry type access
* (api): spec download logic
* (apigateway): image source type checking
* image copying from registry
* (image): include tag state from output ([#745](https://github.com/hamlet-io/engine-plugin-aws/issues/745))
* (baseline): default file path for image pull
* (baseline): data bucket object ownership
* (image): s3 path when pull image
* (image): source values ([#741](https://github.com/hamlet-io/engine-plugin-aws/issues/741))
* (waf): align inbuilt rules config
* (sqs): typo in sqs encryption policy
* else statement for network acl creation
* map for ipset
* (networking): handling of missing port on acl
* (s3): allow external policy sharing on public
* (baseline): provide correct image for pull ([#733](https://github.com/hamlet-io/engine-plugin-aws/issues/733))
* readonly attribute assignment
* lb path for state attribute ([#730](https://github.com/hamlet-io/engine-plugin-aws/issues/730))
* container image reference ([#728](https://github.com/hamlet-io/engine-plugin-aws/issues/728))
* handle cmk based encryption at rest ([#725](https://github.com/hamlet-io/engine-plugin-aws/issues/725))
* (elasticache): Use number based logic for retention ([#720](https://github.com/hamlet-io/engine-plugin-aws/issues/720))
* (baseline): add extra policies for cmk
* (lb): backend support for lambda ([#716](https://github.com/hamlet-io/engine-plugin-aws/issues/716))
* (module): update link to basline component ([#714](https://github.com/hamlet-io/engine-plugin-aws/issues/714))
* (lb): remove waf version lookup on lb ([#709](https://github.com/hamlet-io/engine-plugin-aws/issues/709))
* remove version on setupWAFRule call ([#708](https://github.com/hamlet-io/engine-plugin-aws/issues/708))
* remove version from waf rule lookup ([#707](https://github.com/hamlet-io/engine-plugin-aws/issues/707))
* (image): handle single level docker tags
* (baselinedata): policy lookup on suboccurrence ([#695](https://github.com/hamlet-io/engine-plugin-aws/issues/695))
* (s3): add delete marker replication handling ([#693](https://github.com/hamlet-io/engine-plugin-aws/issues/693))
* (ecs): handle secrets on ec2 tasks ([#692](https://github.com/hamlet-io/engine-plugin-aws/issues/692))
* athena s3 policy ([#691](https://github.com/hamlet-io/engine-plugin-aws/issues/691))
* (images): output based reference handling ([#689](https://github.com/hamlet-io/engine-plugin-aws/issues/689))
* (es): logging configuration ([#684](https://github.com/hamlet-io/engine-plugin-aws/issues/684))
* (image): case handling for image sources ([#681](https://github.com/hamlet-io/engine-plugin-aws/issues/681))
* (es): log group setup for occurrence ([#683](https://github.com/hamlet-io/engine-plugin-aws/issues/683))
* (image): update image push runbooks ([#679](https://github.com/hamlet-io/engine-plugin-aws/issues/679))
* (dnszone): add domain configuration if setup ([#680](https://github.com/hamlet-io/engine-plugin-aws/issues/680))
* update shared release workflow version
* bugfix for aurora scaling
* (lambda): remove env vars for lambda@edge
* (images): remove filename from CODE_SRC_PREFIX config for mobileapp component ([#673](https://github.com/hamlet-io/engine-plugin-aws/issues/673))
#### Refactorings

* (baseline): bucket policy extensions ([#757](https://github.com/hamlet-io/engine-plugin-aws/issues/757))
* (baseline): bucket policy
* replace reference with function lookups
* (s3): object ownership support ([#732](https://github.com/hamlet-io/engine-plugin-aws/issues/732))
* update policy for aws service to cmk
* (mta): move to using cfn for config set
* (waf): remove wafv1 support
* allow manual trigger of release
* github actions
* (images): Update testing
#### Others

* update changelog ([#694](https://github.com/hamlet-io/engine-plugin-aws/issues/694))
* update changelog ([#671](https://github.com/hamlet-io/engine-plugin-aws/issues/671))

Full set of changes: [`8.8.2...8.9.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.8.2...8.9.0)

## 8.8.2 (2022-10-27)

#### Fixes

* (user): pseudo stack handling and ses removal
* OWASP profile handling and action formatting
* (waf): handle WAFProfiles and metric name
* (db): BASH_SOURCE usage in bash scripts
* (apigateway): authorization values ([#666](https://github.com/hamlet-io/engine-plugin-aws/issues/666))
* (apigateway): Authorization header passthrough ([#665](https://github.com/hamlet-io/engine-plugin-aws/issues/665))
* (apigateway): origin request policy ([#664](https://github.com/hamlet-io/engine-plugin-aws/issues/664))
#### Refactorings

* (cdn): Update origin link attribute name
* (iam): remove transitional policy support ([#663](https://github.com/hamlet-io/engine-plugin-aws/issues/663))
#### Others

* update changelog ([#662](https://github.com/hamlet-io/engine-plugin-aws/issues/662))
* update changelog ([#659](https://github.com/hamlet-io/engine-plugin-aws/issues/659))

Full set of changes: [`8.8.1...8.8.2`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.8.1...8.8.2)

## 8.8.1 (2022-10-17)

#### Fixes

* (network): dns resolver resource references ([#661](https://github.com/hamlet-io/engine-plugin-aws/issues/661))
* (datacatalog): add subset filter for resources

Full set of changes: [`8.8.0...8.8.1`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.8.0...8.8.1)

## 8.8.0 (2022-10-13)

#### New Features

* (waf): add support for more wafv2 rules
* (s3): disable public access by default
* (module): add aws s3 service log datacatalog ([#647](https://github.com/hamlet-io/engine-plugin-aws/issues/647))
* (cw): ensure lambda is deleted with canary
* (userpool): add solution callback urls
* (catalog): add base testing
* (datacatalog): initial support using Glue
* (network): add control over flowlog prefix ([#648](https://github.com/hamlet-io/engine-plugin-aws/issues/648))
* (globaldb): add support for enabling indexes
* add default header policy for placeholders
* (cdn): add enable/disable for error responses
* (cloudfront): complex cdn scenarios
#### Fixes

* (cdn): origin request policy headers ([#657](https://github.com/hamlet-io/engine-plugin-aws/issues/657))
* engine case for rule lookup
* (cdn): use cloudformation to find cdn id
* (network): handle missing subnet lookup
* (s3): oai permissions ([#653](https://github.com/hamlet-io/engine-plugin-aws/issues/653))
* (windows): logContent setup for windows logging
* SerDe naming
* (cdn): Redirect processing ([#643](https://github.com/hamlet-io/engine-plugin-aws/issues/643))
* (waf): various fixes in WAF Handling
* (ecs): handle container tagging for ecs version
* (mobileapp): lookup for firebase properties ([#641](https://github.com/hamlet-io/engine-plugin-aws/issues/641))
* (mobileapp): testing updates
* dynamic value setup for aws secrets
* smtp user permissions in module
* (filetransfer): log group name for subscription
* remove app public attributes
* fall through on missing network
* remove redundant line from script
* (image): use container repository for images
* (ecs): skip lb processing when no lb port
* (efs): correct tag format for access points
* (cloudwatch): dependencies on subscription
* (dnszone): add deployment subset check
* typo in test module
* (cdn): add type checks and fix resource name
* (spa): cdn reference for path
* (cw): update permissions for cw logs to kinesis ([#634](https://github.com/hamlet-io/engine-plugin-aws/issues/634))
* (lambda): check deployment units on function
#### Refactorings

* (network): checks for networked tiers ([#645](https://github.com/hamlet-io/engine-plugin-aws/issues/645))
* (mobileapp): build configuration updates
* remove public app data prefixes
* (network): remove use of segmentObject
* (ec2): av migration to shared provider
#### Others

* update changelog ([#630](https://github.com/hamlet-io/engine-plugin-aws/issues/630))
* (cdn): add testing and fixes

Full set of changes: [`8.7.0...8.8.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.7.0...8.8.0)

## 8.7.0 (2022-08-23)

#### New Features

* (baseline): extension and policy support
* (lb): lambda backend support for lb ([#626](https://github.com/hamlet-io/engine-plugin-aws/issues/626))
* queue topic permission extensions ([#618](https://github.com/hamlet-io/engine-plugin-aws/issues/618))
* (image): aws support for the image component
* (runbook): add push_image runbook for images
* adds extensions and tasks for image management
* (lambda): lambda aliases ([#606](https://github.com/hamlet-io/engine-plugin-aws/issues/606))
* (dyanmicvalues): add support for aws secrets as dynamic values
* (correspondent): add support for AWS pinpoint channels
* (lb): add support for enabling/disbaling conditions
#### Fixes

* incorporate feedback
* (cert): raise error on invalid FQDN
* support dns zone creation without network ([#619](https://github.com/hamlet-io/engine-plugin-aws/issues/619))
* (lb): expand permissions for lambda invoke ([#629](https://github.com/hamlet-io/engine-plugin-aws/issues/629))
* error messages for port lookups ([#628](https://github.com/hamlet-io/engine-plugin-aws/issues/628))
* (lb): protocol checks for nlb
* (lb): action lookup for network load balancer ([#623](https://github.com/hamlet-io/engine-plugin-aws/issues/623))
* (computetask): windows directory creation ([#622](https://github.com/hamlet-io/engine-plugin-aws/issues/622))
* (directory): handle missing config connector
* (healthcheck): add iam service to setup
* (lb): create alerts across all occurrences
* (waf): support v1 -> v2 migrations
* (db): aurora cluster backups ([#616](https://github.com/hamlet-io/engine-plugin-aws/issues/616))
* (lambda): size checking ([#609](https://github.com/hamlet-io/engine-plugin-aws/issues/609))
* (apigateway): handle open ip address groups ([#608](https://github.com/hamlet-io/engine-plugin-aws/issues/608))
* (apigateway): reference versioned lambdas
* (lb): standard error for invalid port mapping
#### Refactorings

* (ecs): lg pass handling ([#607](https://github.com/hamlet-io/engine-plugin-aws/issues/607))
#### Others

* update changelog ([#599](https://github.com/hamlet-io/engine-plugin-aws/issues/599))

Full set of changes: [`8.6.2...8.7.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.6.2...8.7.0)

## 8.6.2 (2022-06-07)

#### Fixes

* (ec2): number formatting for priorities
* (ssm): tag properties for ssm resourcs
* (logs): fix tags applied to log subscription role
* (apigateway): OPTIONS handling with authorisers
* (volumemounts): update Ids and properties in volume mounts
* (kms): policies for kms encryption from via services
#### Refactorings

* (lb): use shared security group for backends
* (cd): move to using a reusable pipeline for changelogs ([#592](https://github.com/hamlet-io/engine-plugin-aws/issues/592))
#### Others

* update changelog ([#590](https://github.com/hamlet-io/engine-plugin-aws/issues/590))
* changelog bump
* changelog bump

Full set of changes: [`8.6.0...8.6.2`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.6.0...8.6.2)

## 8.6.0 (2022-05-26)

#### New Features

* (vpc): support creating security groups without inbound ports
* (lb): add support for lb backends
* (datafeed): add support for data streams as a source
* (cdn): rule priority sorting
* aws logstore implementation  ([#573](https://github.com/hamlet-io/engine-plugin-aws/issues/573))
* (rds): event support ([#569](https://github.com/hamlet-io/engine-plugin-aws/issues/569))
* occurrence level configuration tagging
* (lambda): sqs batch control
* (task): add secrets manager get secret task
* (datastream): aws implementation of data stream ([#575](https://github.com/hamlet-io/engine-plugin-aws/issues/575))
* (lambda): versioned lambda retention policy ([#574](https://github.com/hamlet-io/engine-plugin-aws/issues/574))
* (alertslack): allow setting runtime with param ([#570](https://github.com/hamlet-io/engine-plugin-aws/issues/570))
* (alerts): add filter on alerts for enable status
* add docdb support ([#521](https://github.com/hamlet-io/engine-plugin-aws/issues/521))
* add SES SMTP user module
* (task): add ses smtp password generation task
* (ec2): support IPAddress groups and LB on same port
* only include enabled occurrences in suboccurrence processing
* (lambda): provisioned executions ([#559](https://github.com/hamlet-io/engine-plugin-aws/issues/559))
* (dnszone): add support for private vpc zones
* remove auto state generation for fixutre testing
* (secretsmanager): add read write support fo secrets
* (certificateauthority): intial support with ACMPCA
* (apigateway): mutual TLS attribute ([#548](https://github.com/hamlet-io/engine-plugin-aws/issues/548))
* policy chunking ([#545](https://github.com/hamlet-io/engine-plugin-aws/issues/545))
* ec2 resource outputs and replace updates
* (cdn): only add enabled event handlers
* add s3 runbook tasks
* (cdn): add error for wrong logging region
* (lb): add support for alb as a network target ([#537](https://github.com/hamlet-io/engine-plugin-aws/issues/537))
* add role tag to components if present
* (ec2): zone based control for instances
#### Fixes

* (ecs): tags handling ([#588](https://github.com/hamlet-io/engine-plugin-aws/issues/588))
* handle missing link
* (datastream): typo in attribute name
* (globaldb): tag function call
* (sqs): add dlqName back into setup routine
* handle empty tag sets
* add backup tags for dds
* spelling in message
* (s3): handle notifications for endpoints already deployed
* casing for MulitAZ attribute
* format json content for run task module
* (ec2): fix ordering for cfn init commands
* (ecs): ensure subnets are always treated as an array
* (ecs): paramter types for templates
* typo
* (lb): use suboccurrence for static forwardning
* testing updates ([#556](https://github.com/hamlet-io/engine-plugin-aws/issues/556))
* various updates from testing
* log and account processing
* include Value in getReference
* (computecluster): general fixes
* (iam): inline policy creation from policy set ([#547](https://github.com/hamlet-io/engine-plugin-aws/issues/547))
* (backupstore): tag based conditions
* typo in message
#### Refactorings

* (apigateway): authorization models ([#581](https://github.com/hamlet-io/engine-plugin-aws/issues/581))
* (network): remove baseline components that aren't required
* network subnet function
* move test module loading to product layer
* multiAZ migration to component configuration
* (iam): limits used for policy splitting ([#549](https://github.com/hamlet-io/engine-plugin-aws/issues/549))
* (datavolume): zone filter support for volume mounts
* (datavolume): remove backups from datavolume

Full set of changes: [`8.5.0...8.6.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.5.0...8.6.0)

## 8.5.0 (2022-03-25)

#### New Features

* add additional runbook tasks and modules
* use local engine setup for testing
* (spa): force max-age for config ([#530](https://github.com/hamlet-io/engine-plugin-aws/issues/530))
* (adaptor): adaptor alert support
* add run ecs task support for runbooks
* (mta): add enable/disable handling on rules
* (directory): log forwarding support ([#517](https://github.com/hamlet-io/engine-plugin-aws/issues/517))
* (s3): backup support ([#516](https://github.com/hamlet-io/engine-plugin-aws/issues/516))
* (kinesis): compression support for firehose
* (globaldb): cloudwatch alarms ([#508](https://github.com/hamlet-io/engine-plugin-aws/issues/508))
* (backup): Initial AWS implementation ([#507](https://github.com/hamlet-io/engine-plugin-aws/issues/507))
* (logs): add support for at rest encryption of cw logs
* add baseline encryption module
* (ecs): support for ecs exec
* extended runbooks for access
* (cdn): add support for origin connection timeouts
#### Fixes

* segment seed fixture value ([#535](https://github.com/hamlet-io/engine-plugin-aws/issues/535))
* region lookup for resources
* (healthcheck): add more entropy to naming of health checks
* (db): secret lookup for engine setup
* typo in module
* (healthceheck): testing changes from type to engine
* remove use of isPresent for AV setup
* ipmatch and geomatch for wafv2 ([#518](https://github.com/hamlet-io/engine-plugin-aws/issues/518))
* (db): aurora cluster updates
* (task): kms encrypt parameters
* efs mount script formatting
* (db): ingress security group id
* (sns): add support for encrypted topics
* (lb): logging profile for WAF logs ([#510](https://github.com/hamlet-io/engine-plugin-aws/issues/510))
* (cdn): missing logging profile for waf logging
* (cdn): logging script for wafv1
* clean up old if statement
* (s3): replication validation checking
#### Refactorings

* align the run task module to task
* update ecs task configuration after testing
* move to latest unicycle install process
* update district to district type on group filter ([#534](https://github.com/hamlet-io/engine-plugin-aws/issues/534))
* move ecs container setup to aws provider
* update iam standard policy name
* (iam): standard policies for app components
* (s3): use references for bucket policy
* backup encryption key ([#512](https://github.com/hamlet-io/engine-plugin-aws/issues/512))
* (backup): Configuration options ([#511](https://github.com/hamlet-io/engine-plugin-aws/issues/511))
* attribute sets for global configuration
#### Others

* changelog bump ([#497](https://github.com/hamlet-io/engine-plugin-aws/issues/497))

Full set of changes: [`8.4.0...8.5.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.4.0...8.5.0)

## 8.4.0 (2022-01-06)

#### New Features

* pg_dump runbook
* bastion module with ssh runbook
* (baseline): add ssh key as an attribute
* (lambda): layers and jar file support ([#489](https://github.com/hamlet-io/engine-plugin-aws/issues/489))
* ensure inline code changes on update
* wafv2
* wafv2
* wafv2
* (apigateway): Execution Log Control ([#476](https://github.com/hamlet-io/engine-plugin-aws/issues/476))
* (kinesis): ErrorType in prefix ([#472](https://github.com/hamlet-io/engine-plugin-aws/issues/472))
* (kinesis): Prefix time path control ([#471](https://github.com/hamlet-io/engine-plugin-aws/issues/471))
* add tests for secretstore generation
* (db): add support for secretstore root creds
* add extra details to secret resources
* (ecs): add gpu support to task definitions
* (kinesis): Finer grained partition control
* (ecs): secret injection support
* sesout email identity support
* kinesis dynamic partitioning
* mta inbound role support
* outbound mta
* (subscription): Add filter policy ([#447](https://github.com/hamlet-io/engine-plugin-aws/issues/447))
* testing and fixups
* include domain name in attributes
* (efs): support fsx-windows
* add route53 resolver for AD domain
* enable cfn-lint on all test profiles
* (directory): add aws ad connector
* add s3 replica to account deployments
* (lb): add support for monitoring port resource
* add support for startup action on vpngw
* (secretstore): secret creation
* (s3): bucket location permissions
* vpn inside tunnel config
* (clientvpn): adds support for client vpns
* (lb): support for advanced conditions
* new components ([#413](https://github.com/hamlet-io/engine-plugin-aws/issues/413))
* (linux): cfn-hup support for linux ([#420](https://github.com/hamlet-io/engine-plugin-aws/issues/420))
* (av): Add config options for windefender
* enable cfnlint for testing
#### Fixes

* (lambda): ensure layers is not null ([#490](https://github.com/hamlet-io/engine-plugin-aws/issues/490))
* (bastion): hanlde replacement for ec2 instances
* (apigateway): fix id lookup on waf setup
* (apigateway): handle missing log group on creation
* s3 versioning without lifecycle management ([#486](https://github.com/hamlet-io/engine-plugin-aws/issues/486))
* mta rule references
* run code join in resource
* s3 topic queue permission checking
* type structure
* (cloudwatchslack): change topic priority
* ebs volume zone lookup
* lowercase version
* (s3): allow for notifications to be disabled
* secretLink setup
* root credential link fix
* db secret lookup
* handle state lookup before deployment
* Admin username condition
* (directory): handle the rename of root to Admin
* (network): add outputs for key vpc resources
* (kinesis): double slash in prefixes
* reference for secret link access
* syntax error
* execution role for task
* (kinesis): minimum buffer hint ([#466](https://github.com/hamlet-io/engine-plugin-aws/issues/466))
* email identity ([#465](https://github.com/hamlet-io/engine-plugin-aws/issues/465))
* (ecs): support aws prefix for awsvpc
* kinesis firehose s3 record delimiters
* (mta): send SNS topic subscriptions
* policy migration for outbound emails
* default principals
* per AZ vpc endpoints ([#458](https://github.com/hamlet-io/engine-plugin-aws/issues/458))
* revert log stream names
* Kinesis delivery stream S3 permissions
* ses account deployment unit name
* (lb): target group id lookup ([#452](https://github.com/hamlet-io/engine-plugin-aws/issues/452))
* (ds): security group update fix ([#440](https://github.com/hamlet-io/engine-plugin-aws/issues/440))
* (lb): handle missing alerts on lbport
* typo in vpn config
* handle missing startup action
* generated secret macro
* update function name for queuehost
* (healthcheck): update Type property to  Engine
* service definition
* (mta): sns policy for notifications
* handle change to secret store link attribute
* (ds): icmp non-global security rule ([#438](https://github.com/hamlet-io/engine-plugin-aws/issues/438))
* (ds): Remove redundant sg and modify sg to align with IPAddressGroups ([#428](https://github.com/hamlet-io/engine-plugin-aws/issues/428))
* (s3): handle full access to buckets
* include dependencies option
* (directory): add dependency on root creds
* various vpn gateway fixes
* (router): handling of local transit gws
* install engine before set
* accountRegion access
* segmentSeed accessor
* revert bucket access
* error typo
* (av): correct unconfigure for av
* (awswin): refactor volmount to handle cfn-hup
* (awswin): cfn-hup support added
* db zone handling
* typo
* (tags): ensure values exist before use
* (directory): hostname configuration option
* check for assigment type ([#415](https://github.com/hamlet-io/engine-plugin-aws/issues/415))
#### Refactorings

* align ssh_session module with new syntax
* containerregistry source details
* removal of implicit Enabled attribute ([#491](https://github.com/hamlet-io/engine-plugin-aws/issues/491))
* always call invokeExtensions
* remove plural types on attribute set
* (mta): update send configuration for mta
* move role to default component config
* (topic): move sns topic policy to topic
* delivery stream encrpytion changes ([#457](https://github.com/hamlet-io/engine-plugin-aws/issues/457))
* align rename of component type for efs
* rename efs to fileshare
* split efs and fsx services
* replace eval with eval_json
* make transitgw routes based on CIDR
* accessor function names
* setContext wrapper functions (1)
* cfn-lint configuration
* use aws cli query for regions
* remove dos2unix
* (directory): attributes and ip access
#### Others

* changelog bump ([#355](https://github.com/hamlet-io/engine-plugin-aws/issues/355))

Full set of changes: [`8.3.0...8.4.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.3.0...8.4.0)

## 8.3.0 (2021-09-17)

#### New Features

* (ds): New Component - Directory Services ([#392](https://github.com/hamlet-io/engine-plugin-aws/issues/392))
* (av): Windows Defender logging to CloudWatch and definition updates ([#409](https://github.com/hamlet-io/engine-plugin-aws/issues/409))
* (cache): handle new redis versions
* (firewall): fix link issue for destinations
* (firewall): destination route support ([#405](https://github.com/hamlet-io/engine-plugin-aws/issues/405))
* (lb): add check for conditions on default
* (cdn): include internal fqdn in state
* (gateway): support IGW internal routing
* add tests for hostname filter checking
* (iam): tags ([#386](https://github.com/hamlet-io/engine-plugin-aws/issues/386))
* add support for http backends on cdn
* initial test cases for firewall
* add initial firewall implementation
* add support for resource type mocks
* (apigateway): tags ([#371](https://github.com/hamlet-io/engine-plugin-aws/issues/371))
* add route53resolver service
* (network): dns query logging
* windows based ec2 instances ([#301](https://github.com/hamlet-io/engine-plugin-aws/issues/301))
* (SNS): tags
* add all account units
* (tests): add basic testing for service
* support output suffixes on template setup
* set larger default value for SQS MessageRetentionPeriod
#### Fixes

* (bastion): fix eip allocation
* (firewall): align routes to AZ endpoints
* (cache): zone config params
* (firewall): provide occurrence for ip address
* (firewall): missing reference for stateful rule ([#404](https://github.com/hamlet-io/engine-plugin-aws/issues/404))
* typo
* (igw): firewall route hanlding
* (queuehost): reference to wrong sec group id
* (firewall): include sid for stateful rules ([#399](https://github.com/hamlet-io/engine-plugin-aws/issues/399))
* whatif processing ([#400](https://github.com/hamlet-io/engine-plugin-aws/issues/400))
* API Gateway deployment tags ([#401](https://github.com/hamlet-io/engine-plugin-aws/issues/401))
* (network): handling missing network on segments ([#398](https://github.com/hamlet-io/engine-plugin-aws/issues/398))
* (baseline): handle aws required ssh key format
* (firewall): s3 log type detection
* openapi stripping ([#395](https://github.com/hamlet-io/engine-plugin-aws/issues/395))
* handle empty domain names on api gateway
* force certificate if required
* (lb): allow hostname config on http and https
* (lb): handle missing fqdn ([#377](https://github.com/hamlet-io/engine-plugin-aws/issues/377))
* set windows instance sizes to usable defaults
* network tests ([#382](https://github.com/hamlet-io/engine-plugin-aws/issues/382))
* legacy VPC detection
* vpc mock value
* service definition details
* handle missing domains for cert formatting
* bastion eip
* account cmk deployment scope
* missing deployment unit
* (ecs): fix profile lookup for subcomponents ([#357](https://github.com/hamlet-io/engine-plugin-aws/issues/357))
#### Refactorings

* (lb): support for default rule control
* (network): testing updates
* use paramters for az - cfnlint
* move fqdn and certs to state
#### Others

* testing updates
* (network): testing coverage

Full set of changes: [`8.2.1...8.3.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.2.1...8.3.0)

## 8.2.1 (2021-07-09)

#### Fixes

* syntax typo
* (ci): tag push tigger
#### Refactorings

* release process tag support

Full set of changes: [`8.2.0...8.2.1`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.2.0...8.2.1)

## 8.2.0 (2021-07-09)

#### New Features

* draft changelog pr
* s3 flowlog expiration ([#343](https://github.com/hamlet-io/engine-plugin-aws/issues/343))
* move testing to Github Actions
* (secretsmanager): make kms optional
* (template): parameter macro support
* (userpool): add issuer url in state attributes
* symlink for docker-compose install
* add support Startup Timeout configuration
* management port configuration
* (ecs): add support for placement strategies
* (dataset): basic tests for dataset component
* (dataset): add support for external s3 sets
* add support for docker packaging
* (lambda): check env size ([#320](https://github.com/hamlet-io/engine-plugin-aws/issues/320))
* (datapieline): base testing module
* (datapipeline): adds support for url image
#### Fixes

* change priority on default vpcendpoints
* (ci): default docker tagging handling
* dockerignore for git
* minor updates and fix changelog version
* (lb): missing route table link
* trigger package after testing
* (ci): control push based on ref
* use latest for unreleased updates
* (ecs): handle daemon launch mode for ec2 hosts
* (adaptor): asfile settings handling
* (secretsmanager): make secret string optional
* changelog generation
* bootstrap casing fixes
* (ci): add pull request trigger
* add pr build support
* update get profile calls ([#334](https://github.com/hamlet-io/engine-plugin-aws/issues/334))
* API Gateway Schema naming constraint ([#323](https://github.com/hamlet-io/engine-plugin-aws/issues/323))
* (lb): only validate cert when required
* (lambda): revert environment variable refactor
* (s3): list permissions for s3 buckets
* add pregeneration subset
#### Refactorings

* use array for ssh keys
* (ci): install stable cli and update tags
* (ci): ignore the git dir in docker
* remove direct references to region ([#349](https://github.com/hamlet-io/engine-plugin-aws/issues/349))
* volume handling on ec2 instances
* (es): rename storage profile config
* standarise the profile lookup process
* remove use of segmentQualifier ([#325](https://github.com/hamlet-io/engine-plugin-aws/issues/325))
* update segment unit priorties
#### Others

* include build details in container image
* changelog bump ([#347](https://github.com/hamlet-io/engine-plugin-aws/issues/347))

Full set of changes: [`8.1.2...8.2.0`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.1.2...8.2.0)

## 8.1.2 (2021-05-17)

#### New Features

* basic test for contentnode
* (contentnode): external image source support
* add tests for mobile app
* (mobileapp): image source support
* add docker and docker compose compute tasks  ([#292](https://github.com/hamlet-io/engine-plugin-aws/issues/292))
* (adaptor): support for adaptor attributes
* (globadb): support for change streams
* (ec2): handle post tasks for ec2
* (apigateway): mutualTLS support
* add basic tests for computecluster
* (computecluster): add image source support
* (apigateway): opeanpi fragment and vpclink
* add support for creating vpclinks on lb
* add support for API Gateway VPC link
* set healthcheck as default monitor
* base permissions policies for ec2
* (ecs): align with latest aws features
* adds support for healthchecks
* (ec2): adds support for autoscale lifecycles
* awslinux2 support for ec2 instances ([#276](https://github.com/hamlet-io/engine-plugin-aws/issues/276))
* AWS image source attribute sets
* add ec2 image source support for aws
* aws compute task implementations
* private bastion ([#166](https://github.com/hamlet-io/engine-plugin-aws/issues/166))
* (apigateway): Image sourcing ([#267](https://github.com/hamlet-io/engine-plugin-aws/issues/267))
* (cd): setup latest hamlet on each run
* (baseline): add invoke inbound policy for data ([#263](https://github.com/hamlet-io/engine-plugin-aws/issues/263))
* Cloudformation parameter support ([#262](https://github.com/hamlet-io/engine-plugin-aws/issues/262))
* (sqs): ordering configuration for queues
* (userpool): adds constraints for schema ([#245](https://github.com/hamlet-io/engine-plugin-aws/issues/245))
* (gateway): vpn gateway dpd action
* input seeders ([#236](https://github.com/hamlet-io/engine-plugin-aws/issues/236))
* (modules): add no_master modules
* whatif input provider ([#233](https://github.com/hamlet-io/engine-plugin-aws/issues/233))
* (s3): adds bucket policy for inventory ([#230](https://github.com/hamlet-io/engine-plugin-aws/issues/230))
* (ec2): rename an additional authorized_keys file
* (ec2): refactor getInitConfigSSHPublicKeys method
* (ec2): SSH Key Import to ec2 instances
* baselinekey extensions and policy migration ([#229](https://github.com/hamlet-io/engine-plugin-aws/issues/229))
* (s3): inventory report support
* (federatedrole): support for env in assignemnts ([#217](https://github.com/hamlet-io/engine-plugin-aws/issues/217))
* (spa): image source via url ([#216](https://github.com/hamlet-io/engine-plugin-aws/issues/216))
* (userpool): extension support for providers ([#215](https://github.com/hamlet-io/engine-plugin-aws/issues/215))
* (template): url image source ([#211](https://github.com/hamlet-io/engine-plugin-aws/issues/211))
* (s3): extension support for bucket policy [#203](https://github.com/hamlet-io/engine-plugin-aws/issues/203)
* add changelog generation ([#210](https://github.com/hamlet-io/engine-plugin-aws/issues/210))
* (output): add replace function for outputs
* (queuehost): encrypted url and secret support
* (queuehost): initial testing
* (queuehost): aws deployment support
* (cdn): add support for external service origins
* (ecs): external image sourcing
* globaldb secondary indexes ([#204](https://github.com/hamlet-io/engine-plugin-aws/issues/204))
* (kms): region based arn lookup
* (account): s3 account bucket naming
* (lambda): extension version control
* Message Transfer Agent components
* fragment to extension migration ([#194](https://github.com/hamlet-io/engine-plugin-aws/issues/194))
* (alerts): get metric dimensions from blueprint ([#193](https://github.com/hamlet-io/engine-plugin-aws/issues/193))
* (secretstore): secrets manager support ([#189](https://github.com/hamlet-io/engine-plugin-aws/issues/189))
* (consolidatelogs): support deployment prefixes in datafeed prefix
* (datafeed): support adding deployment prefixes to datafeeds
* (logging): add deploy prefixes to log collectors
* (consolidatelogs): enable network flow log
* (baseline): s3 attrs on baseline data
* (network): user defined network flow logs
* (s3): bucket replication to ext services ([#183](https://github.com/hamlet-io/engine-plugin-aws/issues/183))
* autoscale replacement updates
* patching via init script
* enable replication from baselinedata buckets to s3
* (amazonmq): add support for amazonmq as a service
* WAF logs lifecycle rule ([#164](https://github.com/hamlet-io/engine-plugin-aws/issues/164))
* add compute provider support to ecs host ([#150](https://github.com/hamlet-io/engine-plugin-aws/issues/150))
* (awsdiagrams): adds diagram mappings for aws resources
* resource to service mappings
* (ecs): adds support for ulimits on tasks
* authorizer lambda permissions
* copy openapi definition file to authorizers ([#137](https://github.com/hamlet-io/engine-plugin-aws/issues/137))
* sync authorizer openapi spec with api
* "account" and fixed build scope ([#129](https://github.com/hamlet-io/engine-plugin-aws/issues/129))
* (ecs): placement constraints
* (ecs): add hostname for a task container
* slack message on pipeline fail
* (apigateway): add quota throttling
* (apigateway): allow for throttling apigatway at api, stage and method levels
* (ecs): use deployment group filters on ecs subcomponents ([#120](https://github.com/hamlet-io/engine-plugin-aws/issues/120))
* (ecs): docker based health check support
* (userpool): disable oauth on clients
* (ecs): add support for efs volume mounts to tasks
* (efs): add support for access point and iam mounts in ec2 components
* (efs): add access point provisioning and iam support
* (efs): add iam based policies and access point creation
* add base service roles to masterdata
* (filetransfer): support for security policies
* (filetransfer): base component tests
* (filetransfer): add AWS support for filetransfer component
* (waf): enable log waf logging for waf enabled services
* (ecs): support ingress links for security groups
* (cdn): support links to load balancers
* resource labels
* (lb): add LB target group monitoring dimensions
* (lb): add networkacl support for network engine ([#97](https://github.com/hamlet-io/engine-plugin-aws/issues/97))
* (ssm): supports the use of a dedicated CMK for console access
* ingress/egress security group control
* add bastion to default network profile
* (vpc): security group rules - links profiles
* (s3): KMS permissions for S3 bucket access
* (s3): enable at rest-encryption on buckets
* (s3): Add resource support for S3 Encryption
* (lb): waf support for application lb
* (ec2): volume encryption
* (console): enable SSM session support for all ec2 components
* (console): service policies for ssm session manager
* (gateway): add support for destination port configuration ([#62](https://github.com/hamlet-io/engine-plugin-aws/issues/62))
* (lb): static targets
* (gateway): private dns configuration
* (lb): Support for Network load balancer TLS offload
* (router): support for static routes
* (privateservice): initial implementation ([#50](https://github.com/hamlet-io/engine-plugin-aws/issues/50))
* (router): always set BGP ASN
* (externalnetwork): vpn router supportf
* (gateway): vpn connections to gateways
* (gateway): private gateway support
* (externalnetwork): vpn support for external networks
* (router): add resource sharing between aws accounts
* (gateway): externalservice based router support
* (gateway): gateway support for the router component
* (router): initial support for router component in aws
* (service): add support for transitgateway resources
* (ecs): support udp based port mappings ([#46](https://github.com/hamlet-io/engine-plugin-aws/issues/46))
* (globaldb): initial support for the globalDb component ([#45](https://github.com/hamlet-io/engine-plugin-aws/issues/45))
* (ecs): fargate run task state support ([#44](https://github.com/hamlet-io/engine-plugin-aws/issues/44))
* (apigatewa): add TLS configuration for domain names
* Enhanced checks on userpool auth provider names ([#34](https://github.com/hamlet-io/engine-plugin-aws/issues/34))
* (s3): cdn list support for s3
* (mobileapp): OTA CDN on Routes
* (gateway): link based gateway support
* (userpool): get client secret on deploy
#### Fixes

* (ecs): set launch type on scheduled tasks
* (ecs): capacity provider assocation output
* (globaldb): handle secondary indexs pay per use
* (ec2): fix load balancer registration for ec2 ([#310](https://github.com/hamlet-io/engine-plugin-aws/issues/310))
* (apigateway): use correct link for CA lookup
* (computecluster): remove wait resources ([#302](https://github.com/hamlet-io/engine-plugin-aws/issues/302))
* (ecs): service capacity provider usage
* update ec2 support in cfn
* alias and rename of macro for init
* (adaptor): handler image source build unit
* make env available to non-login sessions
* MTA component SES config detection ([#289](https://github.com/hamlet-io/engine-plugin-aws/issues/289))
* link processing in awslinux vpx lb extension ([#288](https://github.com/hamlet-io/engine-plugin-aws/issues/288))
* test outputs for capacity provider
* testing alignment
* (ec2): param options for compute tasks ([#287](https://github.com/hamlet-io/engine-plugin-aws/issues/287))
* dynamic cmdb loading ([#286](https://github.com/hamlet-io/engine-plugin-aws/issues/286))
* (ec2): compute task lookup location ([#285](https://github.com/hamlet-io/engine-plugin-aws/issues/285))
* (ssh): append a new line after each public key ([#278](https://github.com/hamlet-io/engine-plugin-aws/issues/278))
* use autoscale group name for autoscale group
*  typo in attribute set type
* source details for ami
* workaround removed properties
* workaround for shared changes
* workaround os removal
* (ec2): typo in mount point check ([#270](https://github.com/hamlet-io/engine-plugin-aws/issues/270))
* pseudo stacks ([#268](https://github.com/hamlet-io/engine-plugin-aws/issues/268))
* set engine dir
* (template): change to virtual hosted s3 path
* remove debug statement
* handle naming changes for alerts
* enable fifo on dlq
* invalid config handling for db ([#249](https://github.com/hamlet-io/engine-plugin-aws/issues/249))
* test args for hamlet cmds ([#248](https://github.com/hamlet-io/engine-plugin-aws/issues/248))
* (apigateway): throttle handling for apigw
* correct a number of reference attributes
* masterdata object validation errors
* (bastion): support active config on component ([#234](https://github.com/hamlet-io/engine-plugin-aws/issues/234))
* (baselinekey): update permissions for SES ([#231](https://github.com/hamlet-io/engine-plugin-aws/issues/231))
* remove unnecessary sudo
* (s3): do not validate replica sequence on delete
* flowlog tidyup
* (s3): s3event to lambda fixes
* firehose encryption policy
* better control of opsdata encryption
* permission on globaldb secopndary indexes
* change log generation
* typo in switch name
* enable testing and check for link
* typo in log messaage
* (userpool): set userpool region for multi region deployments
* add lambda attributes to context ([#202](https://github.com/hamlet-io/engine-plugin-aws/issues/202))
* (dynamodb): query scan permissions for read access ([#201](https://github.com/hamlet-io/engine-plugin-aws/issues/201))
* s3 encryption replication role
* prodiver id migration cleanup ([#196](https://github.com/hamlet-io/engine-plugin-aws/issues/196))
* (ecs): require replacement for capacity provider scaling ([#192](https://github.com/hamlet-io/engine-plugin-aws/issues/192))
* (datafeed): use error prefix for errors
* (datafeed): clean prefixes for s3 destinations ([#188](https://github.com/hamlet-io/engine-plugin-aws/issues/188))
* set nat gateway priority for mgmt contract
* (baseline): disable encryption at rest by default
* (baseline): use s3 encryption for opsdata
* (ecs): handle scale in protection during updates
* bastion eip subset
* (datafeed): encryption logic and disable backup ([#175](https://github.com/hamlet-io/engine-plugin-aws/issues/175))
* s3 event notification lookup ([#176](https://github.com/hamlet-io/engine-plugin-aws/issues/176))
* (consolidatelogs): disable log fwd for datafeed ([#174](https://github.com/hamlet-io/engine-plugin-aws/issues/174))
* add description for API Gateway service role
* remove check for unique regions between replicating buckets
* (apigateway): waf depedency on stage ([#163](https://github.com/hamlet-io/engine-plugin-aws/issues/163))
* (apigateway): fix new deployments without stage
* (lb): fix logging setup process ([#159](https://github.com/hamlet-io/engine-plugin-aws/issues/159))
* (logstreaming): fixes to logstreaming setup
* add descriptions to service linked roles
* inbounPorts for containers ([#151](https://github.com/hamlet-io/engine-plugin-aws/issues/151))
* align testcases with scenerios config ([#149](https://github.com/hamlet-io/engine-plugin-aws/issues/149))
* diagram mapping for ecs ([#145](https://github.com/hamlet-io/engine-plugin-aws/issues/145))
* (networkacl): use the id instead of existing ref for lookups
* formatting of definition file
* spa state handles no baseline ([#136](https://github.com/hamlet-io/engine-plugin-aws/issues/136))
* don't delete authorizer openapi.json file
* fail testing fast
* globaldb sortKey logic
* (federatedrole): fix deployment subset check
* (ecs): volume driver configuration properties
* disable cfn nag on template testing
* Default throttling checks
* Allow for no patterns in apigw.json ([#124](https://github.com/hamlet-io/engine-plugin-aws/issues/124))
* only check patterns for method settings if throttling set
* check pattern verb
* remove unnecessary check around methodSettings
* integration patterns into explicit method path throttles
* enable segment iam resource set ([#122](https://github.com/hamlet-io/engine-plugin-aws/issues/122))
* (ecs): link id for efs setup
* (filetransfer): add support for security group updates using links
* (transfer): security policy name property
* (lambda): log watcher subscription setup
* (resourcelables): add pregeneration subset to iam resource label
* use mock runId for apigw resources
* (awstest): fix file comments
* typo in function name
* (iam): typo in resource deploy check
* only add resource sets for aws
* enable concurrent builds and remove build wait
* only alert on notifications in S3 template
* (sqs): move policy management for a queue into the component
* s3 encrypted bucket policy for ssm
* (ecs): name state for ecs service
* wording
* wording
* (segment): network deployment state lookup
* (bastion): networkprofile for bastion links
* (lb): truncate lb name
* remove FullName for backwards compat
* (lb): ensure lb name meets aws requirements
* naming fixes for large deployments
* (vpc): implement explicit control on egress
* (vpc): remove ports completey for all protocol
* (vpc): support any protocol sec group rules
* (lambda): check vpc access before creating security groups from links
* (cache): remove networkprofile param from security group
* (ecs): combine inbound ports
* (rds): handle string and int for size
* (bastion): publicRouteTable  default value
* security group references for security groups
* (efs): networkacl lookup from parent
* (vpc): Check network rule array items for content
* (rds): change attribute types inline with cfn schema
* remove cf resources check
* Force lambda@edge to have no environment
* (s3): fix for buckets without encryption
* set destination ports for default private service
* (gateway): remove local route check for adding VPC routes
* (lb): minor fix for static targets
* (tests): mkdir not mrkdir
* (lb): remove debug
* (privateservice): only error during subset
* typo in gateway and router components
* (router): remove routetable requirement for external router
* (router): fix id generation for resourceShare
* (transitgateway): remove dynamic tags from cfn updates
* Permit iam/lg passes before component created
* (gateway): subset control for CFN resources
* Permit iam/lg pass for uncreated components
* (router): align macro with setup
* (gateway): spelling typo
* (cdn): add behaviour for mobile ota
* (cdn): dont use s3 website endpoint in s3 backed origins ([#35](https://github.com/hamlet-io/engine-plugin-aws/issues/35))
* Gateway endpoint es role
* Auth provider configuration defaulting logic
* hamlet test generate command
* template testing script
* init configuration ordering for ec2
* check component subset for cfn resources
#### Refactorings

* use specific contexts for replaces
* reduce required templates
* (ecs): move provider attributes
* update output properties for new format
* support for compute task configuration
* support for compute tasks in init config
* update extensions for images
* move to using compute instance
* rename env vars to hamlet
* composite template inclusion ([#266](https://github.com/hamlet-io/engine-plugin-aws/issues/266))
* bastion ipaddressgroups on component def ([#246](https://github.com/hamlet-io/engine-plugin-aws/issues/246))
* state processing ([#261](https://github.com/hamlet-io/engine-plugin-aws/issues/261))
* align with CLO update
* output hanlding in engine ([#256](https://github.com/hamlet-io/engine-plugin-aws/issues/256))
* command line and masterdata access ([#255](https://github.com/hamlet-io/engine-plugin-aws/issues/255))
* aws cloudwatch metrics ([#253](https://github.com/hamlet-io/engine-plugin-aws/issues/253))
* use org templates as default ([#242](https://github.com/hamlet-io/engine-plugin-aws/issues/242))
* migrate to context paths ([#232](https://github.com/hamlet-io/engine-plugin-aws/issues/232))
* limit check of deprecated config
* define links as attributesets
* composite object types instead of type
* use replace output value
* inbound mta support
* (network): update flow log to match on action
* (consolidatelogs): remove logwatcher support
* (datafeed): update aws-specific attr desc. to explain purpos
* align setup macros with layer data changes ([#153](https://github.com/hamlet-io/engine-plugin-aws/issues/153))
* align testing scenarios with new format
* switch COT to Hamlet ([#134](https://github.com/hamlet-io/engine-plugin-aws/issues/134))
* replace model flows with flows
* align testing with entrances
* update output to align with flow support
* test genertion using management contract
* (ec2): add volume encryption kms key support
* replace script service linked roles with account level
* issue templates
* API Gateway and Lambda S3 config file management
* (service): variable for subnetlist resource type
* API version optional for facbook IdP
#### Docs

* Provider Modules ([#240](https://github.com/hamlet-io/engine-plugin-aws/issues/240))
#### Others

* update changelog ([#308](https://github.com/hamlet-io/engine-plugin-aws/issues/308))
* (deps): bump lodash from 4.17.20 to 4.17.21 ([#303](https://github.com/hamlet-io/engine-plugin-aws/issues/303))
* (deps): bump handlebars from 4.7.6 to 4.7.7 ([#297](https://github.com/hamlet-io/engine-plugin-aws/issues/297))
* (deps): bump hosted-git-info from 2.8.8 to 2.8.9 ([#298](https://github.com/hamlet-io/engine-plugin-aws/issues/298))
* testing for ec2 based components ([#275](https://github.com/hamlet-io/engine-plugin-aws/issues/275))
* release notes
* review the plugin readme ([#243](https://github.com/hamlet-io/engine-plugin-aws/issues/243))
* changelog
* changelog
* (s3): add testing for s3 notifications
* (awstest): add tests for apigateway and s3
