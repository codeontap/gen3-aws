[#ftl]

[#macro aws_computecluster_cf_state occurrence parent={} ]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution ]

    [#local autoScaleGroupId = formatResourceId( AWS_EC2_AUTO_SCALE_GROUP_RESOURCE_TYPE, core.Id )]
    [#local securityGroupId = formatResourceId( AWS_VPC_SECURITY_GROUP_RESOURCE_TYPE, core.Id )]

    [#local autoScaling = {}]
    [#if solution.ScalingPolicies?has_content ]
        [#list solution.ScalingPolicies as name, scalingPolicy ]

            [#if scalingPolicy.Type == "scheduled" ]
                [#local autoScaling +=
                    {
                        "scalingPolicy" + name : {
                            "Id" : formatDependentAutoScalingEc2ScheduleId(autoScaleGroupId, name),
                            "Name" : formatName(core.FullName, name),
                            "Type" : AWS_AUTOSCALING_EC2_SCHEDULE_RESOURCE_TYPE
                        }
                    }
                ]
            [#else]
                [#local autoScaling +=
                    {
                        "scalingPolicy" + name : {
                            "Id" : formatDependentAutoScalingEc2PolicyId(autoScaleGroupId, name),
                            "Name" : formatName(core.FullName, name),
                            "Type" : AWS_AUTOSCALING_EC2_POLICY_RESOURCE_TYPE
                        }
                    }
                ]
            [/#if]
        [/#list]
    [/#if]

    [#local image = constructAWSImageResource(occurrence, "scripts", {}, "default")]

    [#assign componentState =
        {
            "Resources" : {
                "securityGroup" : {
                    "Id" : securityGroupId,
                    "Name" : core.FullName,
                    "Type" : AWS_VPC_SECURITY_GROUP_RESOURCE_TYPE
                },
                "role" : {
                    "Id" : formatResourceId( AWS_IAM_ROLE_RESOURCE_TYPE, core.Id ),
                    "Type" : AWS_IAM_ROLE_RESOURCE_TYPE,
                    "IncludeInDeploymentState" : false
                },
                "instanceProfile" : {
                    "Id" : formatResourceId( AWS_EC2_INSTANCE_PROFILE_RESOURCE_TYPE, core.Id ),
                    "Type" : AWS_EC2_INSTANCE_PROFILE_RESOURCE_TYPE
                },
                "autoScaleGroup" : {
                    "Id" : autoScaleGroupId,
                    "Name" : core.FullName,
                    "Type" : AWS_EC2_AUTO_SCALE_GROUP_RESOURCE_TYPE,
                    "ComputeTasks" : [
                        COMPUTE_TASK_RUN_STARTUP_CONFIG,
                        COMPUTE_TASK_AWS_CFN_SIGNAL,
                        COMPUTE_TASK_AWS_ASG_STARTUP_SIGNAL,
                        COMPUTE_TASK_SYSTEM_VOLUME_MOUNTING,
                        COMPUTE_TASK_FILE_DIR_CREATION,
                        COMPUTE_TASK_HAMLET_ENVIRONMENT_VARIABLES,
                        COMPUTE_TASK_OS_SECURITY_PATCHING,
                        COMPUTE_TASK_ANTIVIRUS_CONFIG,
                        COMPUTE_TASK_AWS_CLI,
                        COMPUTE_TASK_SYSTEM_LOG_FORWARDING,
                        COMPUTE_TASK_USER_ACCESS,
                        COMPUTE_TASK_EFS_MOUNT,
                        COMPUTE_TASK_RUN_SCRIPTS_DEPLOYMENT,
                        COMPUTE_TASK_AWS_LB_REGISTRATION
                    ]
                },
                "lg" : {
                    "Id" : formatLogGroupId(core.Id),
                    "Name" : core.FullAbsolutePath,
                    "Type" : AWS_CLOUDWATCH_LOG_GROUP_RESOURCE_TYPE,
                    "IncludeInDeploymentState" : false
                },
                "launchConfig" : {
                    "Id" : solution.AutoScaling.AlwaysReplaceOnUpdate?then(
                            formatResourceId(
                                AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE,
                                core.Id,
                                [#-- changing the launch config logical Id forces a replacement of the autoscale group instances --]
                                [#-- we only want this to happen when the build reference changes --]
                                replaceAlphaNumericOnly((image.default.Reference)!""),
                                getCLORunId()
                            ),
                            formatResourceId(
                                AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE,
                                core.Id,
                                [#-- changing the launch config logical Id forces a replacement of the autoscale group instances --]
                                [#-- we only want this to happen when the build reference changes --]
                                replaceAlphaNumericOnly((image.default.Reference)!""))
                    ),
                    "Type" : AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE
                }
            } +
            autoScaling,
            "Images": image,
            "Attributes" : {
            },
            "Roles" : {
                "Inbound" : {
                    "networkacl" : {
                        "SecurityGroups" : securityGroupId,
                        "Description" : core.FullName
                    }
                },
                "Outbound" : {
                    "networkacl" : {
                        "Ports" : solution.ComputeInstance.ManagementPorts,
                        "SecurityGroups" : securityGroupId,
                        "Description" : core.FullName
                    }
                }
            }
        }
    ]
[/#macro]
