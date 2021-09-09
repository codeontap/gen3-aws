[#ftl]
[#macro aws_bastion_cf_state occurrence parent={} ]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local securityGroupToId = formatResourceId( AWS_VPC_SECURITY_GROUP_RESOURCE_TYPE, core.Id )]

    [#assign componentState =
        {
            "Resources" : {
                "eip" : {
                    "Id" : formatEIPId(core.Id),
                    "Name" : core.FullName,
                    "Type" : AWS_EIP_RESOURCE_TYPE
                },
                "securityGroupTo" : {
                    "Id" : securityGroupToId,
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
                    "Id" : formatResourceId( AWS_EC2_AUTO_SCALE_GROUP_RESOURCE_TYPE, core.Id ),
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
                        COMPUTE_TASK_AWS_CLI,
                        COMPUTE_TASK_SYSTEM_LOG_FORWARDING,
                        COMPUTE_TASK_AWS_EIP,
                        COMPUTE_TASK_USER_ACCESS,
                        COMPUTE_TASK_EFS_MOUNT,
                        COMPUTE_TASK_USER_BOOTSTRAP
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
                                formatResourceId(AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE, core.Id, getCLORunId()),
                                formatResourceId(AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE, core.Id)
                    ),
                    "Type" : AWS_EC2_LAUNCH_CONFIG_RESOURCE_TYPE
                },
                "maintenanceWindow" : {
                    "Id" : formatResourceId(AWS_SSM_MAINTENANCE_WINDOW_RESOURCE_TYPE, core.Id),
                    "Name" : core.FullName,
                    "Type" : AWS_SSM_MAINTENANCE_WINDOW_RESOURCE_TYPE
                },
                "maintenanceWindowTarget" : {
                    "Id" : formatResourceId(AWS_SSM_MAINTENANCE_WINDOW_TARGET_RESOURCE_TYPE, core.Id),
                    "Name" : core.FullName,
                    "Type" : AWS_SSM_MAINTENANCE_WINDOW_TARGET_RESOURCE_TYPE
                },
                "patchingMaintenanceTask" : {
                    "Id" : formatResourceId(AWS_SSM_MAINTENANCE_WINDOW_TASK_RESOURCE_TYPE, core.Id, "patching"),
                    "Name" : formatName(core.FullName, "patching"),
                    "Type" : AWS_SSM_MAINTENANCE_WINDOW_TASK_RESOURCE_TYPE
                },
                "maintenanceRole" : {
                    "Id" : formatResourceId(AWS_IAM_ROLE_RESOURCE_TYPE, core.Id, "maintenance"),
                    "Type" : AWS_IAM_ROLE_RESOURCE_TYPE,
                    "IncludeInDeploymentState" : false
                }
            },
            "Attributes" : {
            },
            "Roles" : {
                "Inbound" : {
                    "networkacl" : {
                        "SecurityGroups" : securityGroupToId,
                        "Description" : core.FullName
                    }
                },
                "Outbound" : {
                    "networkacl" : {
                        "Ports": solution.ComputeInstance.ManagementPorts,
                        "SecurityGroups" : securityGroupToId,
                        "Description" : core.FullName
                    }
                }
            }
        }
    ]
[/#macro]
