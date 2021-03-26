[#ftl]

[#assign AWS_EC2_AUTO_SCALE_GROUP_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[#assign AWS_EC2_EBS_VOLUME_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[@addOutputMapping
    provider=AWS_PROVIDER
    resourceType=AWS_EC2_AUTO_SCALE_GROUP_RESOURCE_TYPE
    mappings=AWS_EC2_AUTO_SCALE_GROUP_OUTPUT_MAPPINGS
/]

[@addOutputMapping
    provider=AWS_PROVIDER
    resourceType=AWS_EC2_EBS_RESOURCE_TYPE
    mappings=AWS_EC2_EBS_VOLUME_OUTPUT_MAPPINGS
/]

[#function getInitConfig configSetName configKeys=[] ]
    [#local configSet = [] ]
    [#list configKeys as key,value ]
        [#local configSet += [ key ]]
    [/#list]

    [#return {
        "AWS::CloudFormation::Init" : {
            "configSets" : {
                configSetName : configSet?sort
            }
        } + configKeys
    } ]
[/#function]

[#function getInitConfigDirectories ignoreErrors=false priority=0 ]
    [#return
        {
            "${priority}_Directories" : {
                "commands": {
                    "01Directories" : {
                        "command" : "mkdir --parents --mode=0755 /etc/codeontap && mkdir --parents --mode=0755 /opt/codeontap/bootstrap && mkdir --parents --mode=0755 /opt/codeontap/scripts && mkdir --parents --mode=0755 /var/log/codeontap",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigOSPatching schedule securityOnly=false ignoreErrors=false priority=1 ]
    [#local updateCommand = "yum clean all && yum -y update"]
    [#return
        {
            "${priority}_SecurityUpdates" : {
                "commands": {
                    "InitialUpdate" : {
                        "command" : updateCommand,
                        "ignoreErrors" : ignoreErrors
                    }
                } +
                securityOnly?then(
                    {
                        "DailySecurity" : {
                            "command" : 'echo \"${schedule} ${updateCommand} --security >> /var/log/update.log 2>&1\" >crontab.txt && crontab crontab.txt',
                            "ignoreErrors" : ignoreErrors
                        }
                    },
                    {
                        "DailyUpdates" : {
                            "command" : 'echo \"${schedule} ${updateCommand} >> /var/log/update.log 2>&1\" >crontab.txt && crontab crontab.txt',
                            "ignoreErrors" : ignoreErrors
                        }
                    }
                )
            }
        }
    ]
[/#function]

[#function getInitConfigBootstrap occurrence operationsBucket dataBucket ignoreErrors=false priority=1 ]
    [#local role = (occurrence.Configuration.Settings.Product["Role"].Value)!""]
    [#return
        {
            "${priority}_Bootstrap": {
                "packages" : {
                    "yum" : {
                        "aws-cli" : [],
                        "amazon-efs-utils" : []
                    }
                },
                "files" : {
                    "/etc/codeontap/facts.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    "#!/bin/bash\n",
                                    "echo \"cot:request="       + getCLORequestReference() + "\"\n",
                                    "echo \"cot:configuration=" + getCLOConfigurationReference() + "\"\n",
                                    "echo \"cot:accountRegion=" + accountRegionId         + "\"\n",
                                    "echo \"cot:tenant="        + tenantId                + "\"\n",
                                    "echo \"cot:account="       + accountId               + "\"\n",
                                    "echo \"cot:product="       + productId               + "\"\n",
                                    "echo \"cot:region="        + regionId                + "\"\n",
                                    "echo \"cot:segment="       + segmentId               + "\"\n",
                                    "echo \"cot:environment="   + environmentId           + "\"\n",
                                    "echo \"cot:tier="          + occurrence.Core.Tier.Id + "\"\n",
                                    "echo \"cot:component="     + occurrence.Core.Component.Id + "\"\n",
                                    "echo \"cot:role="          + role                    + "\"\n",
                                    "echo \"cot:credentials="   + credentialsBucket       + "\"\n",
                                    "echo \"cot:code="          + codeBucket              + "\"\n",
                                    "echo \"cot:logs="          + operationsBucket        + "\"\n",
                                    "echo \"cot:backups="       + dataBucket              + "\"\n"
                                ]
                            ]
                        },
                        "mode" : "000755"
                    },
                    "/opt/codeontap/bootstrap/fetch.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    "#!/bin/bash -ex\n",
                                    "exec > >(tee /var/log/codeontap/fetch.log|logger -t codeontap-fetch -s 2>/dev/console) 2>&1\n",
                                    "REGION=$(/etc/codeontap/facts.sh | grep cot:accountRegion | cut -d '=' -f 2)\n",
                                    "CODE=$(/etc/codeontap/facts.sh | grep cot:code | cut -d '=' -f 2)\n",
                                    "aws --region " + r"${REGION}" + " s3 sync s3://" + r"${CODE}" + "/bootstrap/centos/ /opt/codeontap/bootstrap && chmod 0500 /opt/codeontap/bootstrap/*.sh\n"
                                ]
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands": {
                    "01Fetch" : {
                        "command" : "/opt/codeontap/bootstrap/fetch.sh",
                        "ignoreErrors" : ignoreErrors
                    },
                    "02Initialise" : {
                        "command" : "/opt/codeontap/bootstrap/init.sh",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigEnvFacts envVariables={} ignoreErrors=false priority=2 ]

    [#local envContent = [
        "#!/bin/bash"
    ]]

    [#list envVariables as key,value]
        [#local envContent +=
            [
                'echo "${key}=${value}"'
            ]
        ]
    [/#list]

    [#return
        {
            "${priority}_EnvFacts" : {
                "files" : {
                    "/etc/codeontap/env.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                envContent
                            ]
                        },
                        "mode" : "000755"
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigLogAgent logProfile logGroupName ignoreErrors=false priority=2 ]
    [#local logContent = [
        "[general]",
        "state_file = /var/lib/awslogs/agent-state",
        ""
    ]]

    [#list logProfile.LogFileGroups as logFileGroup ]
        [#local logGroup = logFileGroups[logFileGroup] ]
        [#list logGroup.LogFiles as logFile ]
            [#local logFileDetails = logFiles[logFile] ]
            [#local logContent +=
                [
                    "[" + logFileDetails.FilePath + "]",
                    "file = " + logFileDetails.FilePath,
                    "log_group_name = " + logGroupName,
                    "log_stream_name = {instance_id}" + logFileDetails.FilePath
                ] +
                (logFileDetails.TimeFormat!"")?has_content?then(
                    [ "datetime_format = " + logFileDetails.TimeFormat ],
                    []
                ) +
                (logFileDetails.MultiLinePattern!"")?has_content?then(
                    [ "awslogs-multiline-pattern = " + logFileDetails.MultiLinePattern ],
                    []
                ) +
                [ "" ]
            ]
        [/#list]
    [/#list]

    [#return
        {
            "${priority}_LogConfig" : {
                "packages" : {
                    "yum" : {
                        "awslogs" : [],
                        "jq" : []
                    }
                },
                "files" : {
                    "/etc/awslogs/awscli.conf" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                [
                                    "[plugins]",
                                    "cwlogs = cwlogs",
                                    "[default]",
                                    { "Fn::Sub" : r'region = ${AWS::Region}' }
                                ]
                            ]
                        },
                        "mode" : "000644"
                    },
                    "/etc/awslogs/awslogs.conf" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                logContent
                            ]
                        },
                        "mode" : "000644"
                    },
                    "/opt/codeontap/awslogs.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                [
                                    r'#!/bin/bash',
                                    r'# Metadata log details',
                                    r"ecs_cluster=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster')",
                                    r"ecs_container_instance_id=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $2}' )",
                                    r'macs=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/ | head -1 )',
                                    r'vpc_id=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macs/vpc-id )',
                                    r'instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)',
                                    r'',
                                    r'sed -i -e "s/{instance_id}/$instance_id/g" /etc/awslogs/awslogs.conf',
                                    r'sed -i -e "s/{ecs_container_instance_id}/$ecs_container_instance_id/g" /etc/awslogs/awslogs.conf',
                                    r'sed -i -e "s/{ecs_cluster}/$ecs_cluster/g" /etc/awslogs/awslogs.conf',
                                    r'sed -i -e "s/{vpc_id}/$vpc_id/g" /etc/awslogs/awslogs.conf'
                                ]
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "services" : {
                    "sysvinit" : {
                        "awslogs" : {
                            "ensureRunning" : true,
                            "enabled" : true,
                            "files" : [ "/etc/awslogs/awslogs.conf", "/etc/awslogs/awscli.conf" ],
                            "packages" : [ "awslogs" ],
                            "commands" : [ "ConfigureLogsAgent" ]
                        }
                    }
                },
                "commands": {
                    "ConfigureLogsAgent" : {
                        "command" : "/opt/codeontap/awslogs.sh",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigDirsFiles files={} directories={} ignoreErrors=false priority=3]

    [#local initFiles = {} ]
    [#list files as fileName,file ]

        [#local fileMode = (file.mode?length == 3)?then(
                                    file.mode?left_pad(6, "0"),
                                    file.mode )]

        [#local initFiles +=
            {
                fileName : {
                    "content" : {
                        "Fn::Join" : [
                            "\n",
                            file.content
                        ]
                    },
                    "group" : file.group,
                    "owner" : file.owner,
                    "mode"  : fileMode
                }
            }]
    [/#list]

    [#local initDirFile = [
        "#!/bin/bash\n"
        "exec > >(tee /var/log/codeontap/dirsfiles.log|logger -t codeontap-dirsfiles -s 2>/dev/console) 2>&1\n"
    ]]
    [#list directories as directoryName,directory ]

        [#local mode = directory.mode ]
        [#local owner = directory.owner ]
        [#local group = directory.group ]

        [#local initDirFile += [
            'if [[ ! -d "${directoryName}" ]]; then',
            '   mkdir --parents --mode="${mode}" "${directoryName}"',
            '   chown ${owner}:${group} "${directoryName}"',
            'else',
            '   chown -R ${owner}:${group} "${directoryName}"',
            '   chmod ${mode} "${directoryName}"',
            'fi'
        ]]
    [/#list]

    [#return
        { } +
        attributeIfContent(
            "${priority}_CreateDirs",
            directories,
            {
                "files" : {
                    "/opt/codeontap/create_dirs.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                initDirFile
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands" : {
                    "CreateDirScript" : {
                        "command" : "/opt/codeontap/create_dirs.sh",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        ) +
        attributeIfContent(
            "${priority}_CreateFiles",
            files,
            {
                "files" : initFiles
            }

        )
    ]
[/#function]

[#function getInitConfigEIPAllocation allocationIds ignoreErrors=false priority=3 ]

    [#local script = [
        r'#!/bin/bash',
        r'set -euo pipefail',
        r'exec > >(tee /var/log/codeontap/eip.log|logger -t codeontap-eip -s 2>/dev/console) 2>&1',
        r'INSTANCE=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)',
        { "Fn::Sub" : r'export AWS_DEFAULT_REGION="${AWS::Region}"' },
        {
            "Fn::Sub" : [
                r'available_eip="$(aws ec2 describe-addresses --filter "Name=allocation-id,Values=${AllocationIds}" --query ' + r"'Addresses[?AssociationId==`null`].AllocationId | [0]' " + '--output text )"',
                { "AllocationIds": { "Fn::Join" : [ ",", [ allocationIds ] ] }}
            ]
        },
        r'if [[ -n "${available_eip}" && "${available_eip}" != "None" ]]; then',
        r'  aws ec2 associate-address --instance-id ${INSTANCE} --allocation-id ${available_eip} --no-allow-reassociation',
        r'else',
        r'  >&2 echo "No elastic IP available to allocate"',
        r'  exit 255',
        r'fi'
    ]]

    [#return
        {
            "${priority}_AssignEIP" :  {
                "files" : {
                    "/opt/codeontap/eip_allocation.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                script
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands" : {
                    "01AssignEIP" : {
                        "command" : "/opt/codeontap/eip_allocation.sh",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigEFSMount mountId efsId directory osMount accessPointId="" iamEnabled=true  ignoreErrors=false priority=4 ]

    [#local createMount = true]
    [#if directory == "/" ]
        [#local createMount = false ]
    [/#if]

    [#local scriptName = "efs_mount_${mountId}" ]

    [#local script = [
        r'#!/bin/bash',
        'exec > >(tee /var/log/codeontap/${scriptName}.log | logger -t ${scriptName} -s 2>/dev/console) 2>&1'
    ]]

    [#local efsOptions = [ "_netdev", "tls"]]
    [#if iamEnabled ]
        [#local efsOptions += [ "iam" ]]
    [/#if]

    [#if accessPointId?has_content ]
        [#local efsOptions += [ "accesspoint=${accessPointId}" ]]
    [/#if]

    [#local efsOptions = efsOptions?join(",")]

    [#if createMount ]
        [#local script += [
            r'# Create mount dir in EFS',
            r'temp_dir="$(mktemp -d -t efs.XXXXXXXX)"',
            r'mount -t efs "${efsId}:/" ${temp_dir} || exit $?',
            r'if [[ ! -d "${temp_dir}/' + directory + r' ]]; then',
            r'  mkdir -p "${temp_dir}/' + directory + r'"',
            r'  # Allow Full Access to volume (Allows for unkown container access )',
            r'  chmod -R ugo+rwx "${temp_dir}/' + directory + r'"',
            r'fi',
            r'umount ${temp_dir}'
        ]]
    [/#if]

    [#local mountPath = "/mnt/clusterstorage/${osMount}" ]

    [#local script += [
        'mkdir -p "${mountPath}"',
        'mount -t efs -o "${efsOptions}" "${efsId}:${directory}" "${mountPath}"',
        'echo -e "${efsId}:${directory} ${mountPath} efs ${efsOptions} 0 0" >> /etc/fstab'
    ]]

    [#return
        {
            "${priority}_EFSMount_" + mountId : {
                "files" : {
                    "/opt/codeontap/${scriptName}.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "\n",
                                script
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands" :  {
                    "MountEFS" : {
                        "command" : "/opt/codeontap/${scriptName}.sh",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigDataVolumeMount deviceId osMount ignoreErrors=false priority=4 ]
    [#return
        {
            "${priority}_DataVolumeMount_" + deviceId : {
                "commands" :  {
                    "MountDataVolume" : {
                        "command" : "/opt/codeontap/bootstrap/init.sh",
                        "env" : {
                            "DATA_VOLUME_MOUNT_DEVICE" : deviceId?ensure_starts_with("/dev/"),
                            "DATA_VOLUME_MOUNT_DIR" : osMount
                        },
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigECSAgent ecsId defaultLogDriver dockerUsers=[] dockerVolumeDrivers=[] ignoreErrors=false priority=5 ]
    [#local dockerUsersEnv = "" ]

    [#if dockerUsers?has_content ]
        [#list dockerUsers as userName,details ]
            [#local dockerUsersEnv += details.UserName?has_content?then(details.UserName,userName) + ":" + details.UID?c + "," ]
        [/#list]
    [/#if]
    [#local dockerUsersEnv = dockerUsersEnv?remove_ending(",")]

    [#local dockerVolumeDriverEnvs = {} ]
    [#if dockerVolumeDrivers?has_content ]
        [#list dockerVolumeDrivers as dockerVolumeDriver ]
            [#local dockerVolumeDriverEnvs += { "DOCKER_VOLUME_DRIVER_" + dockerVolumeDriver?upper_case : "true" }]
        [/#list]
    [/#if]

    [#return
        {
        "${priority}_ecs": {
            "commands":
                attributeIfTrue(
                    "01Fluentd",
                    defaultLogDriver == "fluentd",
                    {
                        "command" : "/opt/codeontap/bootstrap/fluentd.sh",
                        "ignoreErrors" : ignoreErrors
                    }) +
                {
                    "03ConfigureCluster" : {
                        "command" : "/opt/codeontap/bootstrap/ecs.sh",
                        "env" : {
                            "ECS_CLUSTER" : valueIfContent(
                                                    getExistingReference(ecsId),
                                                    getExistingReference(ecsId),
                                                    getReference(ecsId)
                                            ),
                            "ECS_LOG_DRIVER" : defaultLogDriver
                        } +
                        attributeIfContent(
                            "DOCKER_USERS",
                            dockerUsersEnv
                        ) +
                        (dockerVolumeDriverEnvs?has_content)?then(
                            dockerVolumeDriverEnvs,
                            {}
                        ),
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigUserBootstrap boostrapName bootstrap environment={} ignoreErrors=false priority=7 ]
    [#local scriptStore = scriptStores[bootstrap.ScriptStore ]]
    [#local scriptStorePrefix = scriptStore.Destination.Prefix ]

    [#local userBootstrapPackages = {}]

    [#list bootstrap.Packages!{} as provider,packages ]
        [#local providerPackages = {}]
        [#if packages?is_sequence ]
            [#list packages as package ]
                [#local providerPackages +=
                    {
                        package.Name : [] +
                            (package.Version)?has_content?then(
                                [ package.Version ],
                                []
                            )
                    }]
            [/#list]
        [/#if]
        [#if providerPackages?has_content ]
            [#local userBootstrapPackages +=
                {
                    provider : providerPackages
                }]
        [/#if]
    [/#list]

    [#local bootstrapDir = "/opt/codeontap/user/" + boostrapName ]
    [#local bootstrapFetchFile = bootstrapDir + "/fetch.sh" ]
    [#local bootstrapScriptsDir = bootstrapDir + "/scripts/" ]
    [#local bootstrapInitFile = bootstrapScriptsDir + bootstrap.InitScript!"init.sh" ]

    [#return
        {
            "${priority}_UserBoot_" + boostrapName : {
                "files" : {
                    bootstrapFetchFile: {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    "#!/bin/bash -ex\n",
                                    "exec > >(tee /var/log/codeontap/fetch.log|logger -t codeontap-fetch -s 2>/dev/console) 2>&1\n",
                                    "REGION=$(/etc/codeontap/facts.sh | grep cot:accountRegion | cut -d '=' -f 2)\n",
                                    "CODE=$(/etc/codeontap/facts.sh | grep cot:code | cut -d '=' -f 2)\n",
                                    "aws --region " + r"${REGION}" + " s3 sync s3://" + r"${CODE}/" + scriptStorePrefix + " " + bootstrapScriptsDir + "\n",
                                    "find \"" + bootstrapScriptsDir + "\" -type f -exec chmod u+rwx {} \\;\n"
                                ]
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands": {
                    "01Fetch" : {
                        "command" : bootstrapFetchFile,
                        "ignoreErrors" : ignoreErrors
                    },
                    "02RunScript" : {
                        "command" : bootstrapInitFile,
                        "ignoreErrors" : ignoreErrors,
                        "cwd" : bootstrapScriptsDir
                    } +
                    attributeIfContent(
                        "env",
                        environment
                    )
                } +
                attributeIfContent(
                    "packages",
                    userBootstrapPackages
                )
            }
        }
    ]
[/#function]

[#function getInitConfigScriptsDeployment scriptsFile envVariables={} shutDownOnCompletion=false ignoreErrors=false priority=7 ]
    [#return
        {
            "${priority}_scripts" : {
                "packages" : {
                    "yum" : {
                        "aws-cli" : [],
                        "unzip" : []
                    }
                },
                "files" :{
                    "/opt/codeontap/fetch_scripts.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    "#!/bin/bash -ex\n",
                                    "exec > >(tee /var/log/codeontap/fetch-scripts.log|logger -t codeontap-scripts-fetch -s 2>/dev/console) 2>&1\n",
                                    "REGION=$(/etc/codeontap/facts.sh | grep cot:accountRegion | cut -d '=' -f 2)\n",
                                    "aws --region " + r"${REGION}" + " s3 cp --quiet s3://" + scriptsFile + " /opt/codeontap/scripts\n",
                                    " if [[ -f /opt/codeontap/scripts/scripts.zip ]]; then\n",
                                    "unzip /opt/codeontap/scripts/scripts.zip -d /opt/codeontap/scripts/\n",
                                    "chmod -R 0544 /opt/codeontap/scripts/\n",
                                    "else\n",
                                    "return 1\n",
                                    "fi\n"
                                ]
                            ]
                        },
                        "mode" : "000755"
                    },
                    "/opt/codeontap/run_scripts.sh" : {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    "#!/bin/bash -ex\n",
                                    "exec > >(tee /var/log/codeontap/fetch.log|logger -t codeontap-scripts-init -s 2>/dev/console) 2>&1\n",
                                    "[ -f /opt/codeontap/scripts/init.sh ] &&  /opt/codeontap/scripts/init.sh\n"
                                ]
                            ]
                        },
                        "mode" : "000755"
                    }
                },
                "commands" : {
                    "01RunInitScript" : {
                        "command" : "/opt/codeontap/fetch_scripts.sh",
                        "ignoreErrors" : ignoreErrors
                    },
                    "02RunInitScript" : {
                        "command" : "/opt/codeontap/run_scripts.sh",
                        "cwd" : "/opt/codeontap/scripts/",
                        "ignoreErrors" : ignoreErrors
                    } +
                    attributeIfContent(
                        "env",
                        envVariables,
                        envVariables
                    )
                } + shutDownOnCompletion?then(
                    {
                        "03ShutDownInstance" : {
                            "command" : "shutdown -P +10",
                            "ignoreErrors" : ignoreErrors
                        }
                    },
                    {}
                )
            }
        }
    ]
[/#function]

[#function getInitConfigLBTargetRegistration portId targetGroupArn ignoreErrors=false priority=8]
    [#return
        {
            "${priority}_RegisterWithTG_" + portId  : {
                "commands" : {
                        "RegsiterWithTG" : {
                        "command" : "/opt/codeontap/bootstrap/register_targetgroup.sh",
                        "env" : {
                            "TARGET_GROUP_ARN" : targetGroupArn
                        },
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigLBClassicRegistration lbId ignoreErrors=false priority=8]
    [#return
        {
            "${priority}_RegisterWithLB_" + lbId : {
                "commands" : {
                    "RegisterWithLB" : {
                        "command" : "/opt/codeontap/bootstrap/register.sh",
                        "env" : {
                            "LOAD_BALANCER" : getReference(lbId)
                        },
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getInitConfigSSHPublicKeys SSHPublicKeys linkEnvironment ignoreErrors=false priority=9 ]
    [#local SSHPublicKeysContent = "" ]
    [#list SSHPublicKeys as id,publicKey ]
        [#if (linkEnvironment[publicKey.SettingName])?has_content ]
            [#local SSHPublicKeysContent += linkEnvironment[publicKey.SettingName] + " " + id ]
            [#if (SSHPublicKeys?keys)?seq_index_of(id) != ((SSHPublicKeys?keys)?size - 1)]
                [#local SSHPublicKeysContent += "\n"]
            [/#if]
        [/#if]
    [/#list]
    [#return
        {
            "${priority}_authorized_keys_hamlet" : {
                "files" :{
                    "/home/ec2-user/.ssh/authorized_keys_hamlet" : {
                        "content" : {
                            "Fn::Join" : [
                                "",
                                [
                                    SSHPublicKeysContent
                                ]
                            ]
                        },
                        "mode" : "000600",
                        "group" : "ec2-user",
                        "owner" : "ec2-user"
                    }
                },
                "commands": {
                    "01UpdateSSHDConfig" : {
                        "command" : "sed -i 's#^\\(AuthorizedKeysFile.*$\\)#\\1 .ssh/authorized_keys_hamlet#' /etc/ssh/sshd_config",
                        "ignoreErrors" : ignoreErrors
                    },
                    "02RestartSSHDService" : {
                        "command" : "service sshd restart",
                        "ignoreErrors" : ignoreErrors
                    }
                }
            }
        }
    ]
[/#function]

[#function getBlockDevices storageProfile]
    [#if storageProfile?is_hash ]
        [#if (storageProfile.Volumes)?has_content]
            [#local ebsVolumes = [] ]
            [#list storageProfile.Volumes?values as volume]
                [#if volume?is_hash]
                    [#local ebsVolumes +=
                        [
                            {
                                "DeviceName" : volume.Device,
                                "Ebs" : {
                                    "DeleteOnTermination" : true,
                                    "Encrypted" : false,
                                    "VolumeSize" : volume.Size,
                                    "VolumeType" : "gp2"
                                }
                            }
                        ]
                    ]
                [/#if]
            [/#list]
            [#return
                {
                    "BlockDeviceMappings" :
                        ebsVolumes +
                        [
                            {
                                "DeviceName" : "/dev/sdc",
                                "VirtualName" : "ephemeral0"
                            },
                            {
                                "DeviceName" : "/dev/sdt",
                                "VirtualName" : "ephemeral1"
                            }
                        ]
                }
            ]
        [/#if]
    [/#if]
    [#return {} ]
[/#function]

[#macro createEC2LaunchConfig id
    processorProfile
    storageProfile
    securityGroupId
    instanceProfileId
    resourceId
    imageId
    publicIP
    configSet
    environmentId
    keyPairId
    sshFromProxy=sshFromProxySecurityGroup
    enableCfnSignal=false
    dependencies=""
    outputId=""
]

    [@cfResource
        id=id
        type="AWS::AutoScaling::LaunchConfiguration"
        properties=
            getBlockDevices(storageProfile) +
            {
                "KeyName" : getExistingReference(keyPairId, NAME_ATTRIBUTE_TYPE),
                "InstanceType": processorProfile.Processor,
                "ImageId" : imageId,
                "SecurityGroups" :
                    [
                        getReference(securityGroupId)
                    ] +
                    sshFromProxy?has_content?then(
                        [
                            sshFromProxy
                        ],
                        []
                    ),
                "IamInstanceProfile" : getReference(instanceProfileId),
                "AssociatePublicIpAddress" : publicIP,
                "UserData" : {
                    "Fn::Base64" : {
                        "Fn::Join" : [
                            "",
                            [
                                "#!/bin/bash -ex\n",
                                "exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1\n",
                                "yum install -y aws-cfn-bootstrap\n",
                                "# Remainder of configuration via metadata\n",
                                "/opt/aws/bin/cfn-init -v",
                                "         --stack ", { "Ref" : "AWS::StackName" },
                                "         --resource ", resourceId,
                                "         --region ", regionId, " --configsets ", configSet, "\n"
                            ] + enableCfnSignal?then(
                                [
                                    "# Signal the status from cfn-init\n",
                                    "/opt/aws/bin/cfn-signal -e $? ",
                                    "         --stack ", { "Ref": "AWS::StackName" },
                                    "         --resource ", resourceId,
                                    "         --region ", { "Ref": "AWS::Region" }, "\n"
                                ],
                                []
                            )

                        ]
                    }
                }
            }
        outputs={}
        outputId=outputId
        dependencies=dependencies
    /]
[/#macro]

[#macro createEc2AutoScaleGroup id
    tier
    configSetName
    configSets
    launchConfigId
    processorProfile
    autoScalingConfig
    multiAZ
    tags
    networkResources
    scaleInProtection=false
    hibernate=false
    loadBalancers=[]
    targetGroups=[]
    dependencies=""
    outputId=""
]

    [#if processorProfile.MaxCount?has_content ]
        [#assign maxSize = processorProfile.MaxCount ]
    [#else]
        [#assign maxSize = processorProfile.MaxPerZone]
        [#if multiAZ]
            [#assign maxSize = maxSize * zones?size]
        [/#if]
    [/#if]

    [#if processorProfile.MinCount?has_content ]
        [#assign minSize = processorProfile.MinCount ]
    [#else]
        [#assign minSize = processorProfile.MinPerZone]
        [#if multiAZ]
            [#assign minSize = minSize * zones?size]
        [/#if]
    [/#if]

    [#if maxSize <= autoScalingConfig.MinUpdateInstances ]
        [#assign maxSize = maxSize + autoScalingConfig.MinUpdateInstances ]
    [/#if]

    [#assign desiredCapacity = processorProfile.DesiredCount!multiAZ?then(
                    processorProfile.DesiredPerZone * zones?size,
                    processorProfile.DesiredPerZone
    )]

    [#assign autoscalingMinUpdateInstances = autoScalingConfig.MinUpdateInstances ]
    [#if hibernate ]
        [#assign minSize = 0 ]
        [#assign desiredCapacity = 0 ]
        [#assign maxSize = 1]
        [#assign autoscalingMinUpdateInstances = 0 ]
    [/#if]

    [@cfResource
        id=id
        type="AWS::AutoScaling::AutoScalingGroup"
        metadata=getInitConfig(configSetName, configSets )
        properties=
            {
                "Cooldown" : autoScalingConfig.ActivityCooldown?c,
                "LaunchConfigurationName": getReference(launchConfigId)
            } +
            autoScalingConfig.DetailedMetrics?then(
                {
                    "MetricsCollection" : [
                        {
                            "Granularity" : "1Minute"
                        }
                    ]
                },
                {}
            ) +
            multiAZ?then(
                {
                    "MinSize": minSize,
                    "MaxSize": maxSize,
                    "DesiredCapacity": desiredCapacity,
                    "VPCZoneIdentifier": getSubnets(tier, networkResources)
                },
                {
                    "MinSize": minSize,
                    "MaxSize": maxSize,
                    "DesiredCapacity": desiredCapacity,
                    "VPCZoneIdentifier" : getSubnets(tier, networkResources)[0..0]
                }
            ) +
            attributeIfContent(
                "LoadBalancerNames",
                loadBalancers,
                loadBalancers
            ) +
            attributeIfContent(
                "TargetGroupARNs",
                targetGroups,
                targetGroups
            ) +
            attributeIfTrue(
                "NewInstancesProtectedFromScaleIn",
                scaleInProtection,
                true
            )
        tags=tags
        outputs=AWS_EC2_AUTO_SCALE_GROUP_OUTPUT_MAPPINGS
        outputId=outputId
        dependencies=dependencies
        updatePolicy=autoScalingConfig.ReplaceCluster?then(
            {
                "AutoScalingReplacingUpdate" : {
                    "WillReplace" : true
                }
            },
            {
                "AutoScalingRollingUpdate" : {
                    "WaitOnResourceSignals" : autoScalingConfig.WaitForSignal,
                    "MinInstancesInService" : autoscalingMinUpdateInstances,
                    "MinSuccessfulInstancesPercent" : autoScalingConfig.MinSuccessInstances,
                    "PauseTime" : "PT" + autoScalingConfig.UpdatePauseTime,
                    "SuspendProcesses" : [
                        "HealthCheck",
                        "ReplaceUnhealthy",
                        "AZRebalance",
                        "AlarmNotification",
                        "ScheduledActions"
                    ]
                }
            }
        )
        creationPolicy=
            autoScalingConfig.WaitForSignal?then(
                {
                    "ResourceSignal" : {
                        "Count" : desiredCapacity,
                        "Timeout" : "PT" + autoScalingConfig.StartupTimeout
                    }
                },
                {}
            )
    /]
[/#macro]

[#macro createEBSVolume id
    tags
    size
    zone
    volumeType
    encrypted
    kmsKeyId
    provisionedIops=0
    snapshotId=""
    dependencies=""
    outputId=""
]

    [@cfResource
        id=id
        type="AWS::EC2::Volume"
        properties={
            "AvailabilityZone" : zone.AWSZone,
            "VolumeType" : volumeType,
            "Size" : size
        } +
        (!(snapshotId?has_content) && encrypted)?then(
            {
                "Encrypted" : encrypted,
                "KmsKeyId" : getReference(kmsKeyId, ARN_ATTRIBUTE_TYPE)
            },
            {}
        ) +
        (volumeType == "io1")?then(
            {
                "Iops" : provisionedIops
            },
            {}
        ) +
        (snapshotId?has_content)?then(
            {
                "SnapshotId" : snapshotId
            },
            {}
        )
        tags=tags
        outputs=AWS_EC2_EBS_VOLUME_OUTPUT_MAPPINGS
        outputId=outputId
        dependencies=dependencies
    /]
[/#macro]

[#macro createEBSVolumeAttachment id
    device
    instanceId
    volumeId
]
    [@cfResource
        id=id
        type="AWS::EC2::VolumeAttachment"
        properties={
            "Device" : "/dev/" + device,
            "InstanceId" : getReference(instanceId),
            "VolumeId" : getReference(volumeId)
        }
        outputId=outputId
        dependencies=dependencies
    /]
[/#macro]
