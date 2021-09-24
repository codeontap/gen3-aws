# Changelog

## Unreleased (2021-09-24)

#### Fixes

* (directory): hostname configuration option
* check for assigment type ([#415](https://github.com/hamlet-io/engine-plugin-aws/issues/415))

Full set of changes: [`8.3.0...5c67b7b`](https://github.com/hamlet-io/engine-plugin-aws/compare/8.3.0...5c67b7b)

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
