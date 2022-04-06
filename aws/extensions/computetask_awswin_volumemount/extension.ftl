[#ftl]

[@addExtension
    id="computetask_awswin_volumemount"
    aliases=[
        "_computetask_awswin_volumemount"
    ]
    description=[
        "Uses windows commands to format and mount volumes"
    ]
    supportedTypes=[
        EC2_COMPONENT_TYPE,
        ECS_COMPONENT_TYPE,
        COMPUTECLUSTER_COMPONENT_TYPE,
        BASTION_COMPONENT_TYPE
    ]
    scopes=[
        COMPUTETASK_EXTENSION_SCOPE
    ]
/]

[#macro shared_extension_computetask_awswin_volumemount_deployment_computetask occurrence ]

    [#local storageProfile = _context.StorageProfile ]
    [#local volumes = (storageProfile.Volumes)!{}]

    [#local files = {}]
    [#local commands = {}]

    [#-- Support for data volumes as linked components to single instances --]
    [#if occurrence.Core.Type == EC2_COMPONENT_TYPE ]

        [#-- These volumes are provided through DataVolumes which are an indepdent component --]
        [#-- These are attached to instances through links and VolumeMount macro which applies the extra configuration required --]

        [#list occurrence.State.Resources.Zones as zone, resources]
            [#local instanceId = resources["ec2Instance"].Id]

            [#list (_context.VolumeMounts)![] as mountId,volumeMount ]

                [#local dataVolume = _context.DataVolumes[mountId]!{} ]
                [#if dataVolume?has_content]

                    [#if ! ((dataVolume[zone].VolumeId)!"")?has_content ]

                        [@fatal
                            message="Data Volume missing for Zone ${zone}"
                            context={
                                "Component" : occurrence.Core.RawName,
                                "DataVolume" : dataVolume
                            }
                        /]
                        [#continue]
                    [/#if]

                    [#if ( getCLODeploymentUnitAlternative() != "replace1" ) ]
                        [@createEBSVolumeAttachment
                            id=formatDependentResourceId(
                                AWS_EC2_EBS_ATTACHMENT_RESOURCE_TYPE,
                                zoneEc2InstanceId,
                                dataVolume.Id
                            )
                            device=volumeMount.DeviceId
                            instanceId=zoneEc2InstanceId
                            volumeId=zoneVolume
                        /]
                    [/#if]

                    [#local volumes += {
                        dataVolume.Id : {
                            "Enabled" : true,
                            "MountPath" : volumeMount.MountPath,
                            "Device" : volumeMount.DeviceId,
                            "DataVolume" : true
                        }
                    }]
                [/#if]
            [/#list]
        [/#list]
    [/#if]

    [#local diskId = 0]
    [#list volumes as id,volume ]

        [#local deviceId = ""]
        [#local osMount = ""]

        [#if volume.Enabled && volume.MountPath?? && volume.Device?? ]
            [#local diskId = diskId + 1]
            [#local deviceId = volume.Device]
            [#local osMount = volume.MountPath]
            [#local dataVolume = (volume.DataVolume)!false]
        [#else]
            [#continue]
        [/#if]

        [#local scriptName = "data_volume_mount_" + replaceAlphaNumericOnly(deviceId) ]

        [#local execScript = [
            'Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\${scriptName}.log -Append ;',
            'echo "Starting volume mount" ;',
            'echo "diskId = ${diskId}"; ',
            'echo "deviceId = ${deviceId}"; ',
            'echo "osMount = ${osMount}"; '
        ]]
        [#local execScript += [
            r"$volExists = Get-Volume | Where-Object {$_.DriveLetter -like '" + osMount + r"' } ;",
            'if($volExists) {',
            '   echo "Disk already formatted - ${osMount}" ;'
            '} else { ;'
            '   Initialize-Disk -Number ${diskId} -PartitionStyle MBR 2>&1 | Write-Output ;'
            '   New-Partition -disknumber ${diskId} -UseMaximumSize | Format-Volume -filesystem NTFS -NewFileSystemLabel vol-${deviceId} 2>&1 | Write-Output ;',
            '   Get-Partition -disknumber ${diskId} | Set-Partition -NewDriveLetter ${osMount} 2>&1 | Write-Output',
            '}'
        ]]

        [#local execScript += [
            'Stop-Transcript | out-null'
        ]]

        [#local files += {
            "c:\\ProgramData\\Hamlet\\Scripts\\${scriptName}.ps1" : {
                "content" : {
                    "Fn::Join" : [
                        "\n",
                        execScript
                    ]
                },
                "mode" : "000755"
            }
        }]

        [#local commands += {
            scriptName : {
                "command" : "powershell.exe -ExecutionPolicy Bypass -Command c:\\ProgramData\\Hamlet\\Scripts\\${scriptName}.ps1",
                "ignoreErrors" : false
            }
        }]

    [/#list]


    [#local content = {}]
    [#if files?has_content || commands?has_content ]
        [#local content = {
            "files" : files,
            "commands" : commands
        }]
    [/#if]

    [@computeTaskConfigSection
        computeTaskTypes=[
            COMPUTE_TASK_DATA_VOLUME_MOUNTING,
            COMPUTE_TASK_SYSTEM_VOLUME_MOUNTING
        ]
        id="VolumeMount"
        priority=1
        engine=AWS_EC2_CFN_INIT_COMPUTE_TASK_CONFIG_TYPE
        content=content
    /]

[/#macro]
