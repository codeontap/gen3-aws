[#ftl]

[@addExtension
    id="computetask_awswin_antivirus"
    aliases=[
        "_computetask_awswin_antivirus"
    ]
    description=[
        "Windows Defender AntiVirus Configuration"
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

[#macro shared_extension_computetask_awswin_antivirus_deployment_computetask occurrence ]

    [#local OSPatching = _context.InstanceOSPatching ]
    [#local avConfig = occurrence.Configuration.Solution["aws:AntiVirus"]]

    [#local config_av = []]
    [#local unconfig_av = []]

    [#local config_av += [ 
        r"if(Test-Path -Path 'c:\ProgramData\Hamlet\Scripts\unconfig_av.ps1' -PathType Leaf) { ",
        r"   invoke-expression -Command c:\ProgramData\Hamlet\Scripts\unconfig_av.ps1 ;",
        r"}"
        ]]
    [#if avConfig.Mode != "Active"]
        [#local config_av += [ r'Set-MpPreference -DisableRealtimeMonitoring $true 2>&1 | Write-Output ;' ]]
        [#local unconfig_av += [ r'Set-MpPreference -DisableRealtimeMonitoring $false 2>&1 | Write-Output ;' ]]
    [/#if]
    [#if avConfig.Mode == "Disabled"]
        [#local config_av += [ r' & sc.exe config WinDefend start= disabled 2>&1 | Write-Output ;' ]]
        [#local config_av += [ r' & sc.exe stop WinDefend 2>&1 | Write-Output ;']]
        [#local unconfig_av += [ r' & sc.exe config WinDefend start= enabled 2>&1 | Write-Output ;' ]]
        [#local unconfig_av += [ r' & sc.exe start WinDefend 2>&1 | Write-Output ;']]
    [/#if]
    [#if isPresent(avConfig.Exclusions)]
        [#list avConfig.Exclusions.FilePaths as file]
            [#local config_av += [ r'Add-MpPreference -ExclusionPath "' + file + r'" 2>&1 | Write-Output ;' ]]
            [#local unconfig_av += [ r'Remove-MpPreference -ExclusionPath "' + file + r'" 2>&1 | Write-Output ;' ]]
        [/#list]
        [#list avConfig.Exclusions.Folders as path]
            [#local config_av += [ r'Add-MpPreference -ExclusionPath "' + path + r'" 2>&1 | Write-Output ;' ]]
            [#local unconfig_av += [ r'Remove-MpPreference -ExclusionPath "' + path + r'" 2>&1 | Write-Output ;' ]]
        [/#list]
        [#list avConfig.Exclusions.FileTypes as extn ]
            [#local config_av += [ r'Add-MpPreference -ExclusionExtension "' + extn + r'" 2>&1 | Write-Output ;' ]]
            [#local unconfig_av += [ r'Remove-MpPreference -ExclusionExtension "' + extn + r'" 2>&1 | Write-Output ;' ]]
        [/#list]
    [/#if]
    [#if isPresent(avConfig.ControlledFolders)]
        [#list avConfig.ControlledFolders.Folders as path]
            [#local config_av += [ r'Add-MpPreference -ControlledFolderAccessProtectedFolders "' + path + r'" 2>&1 | Write-Output ;' ]]
            [#local unconfig_av += [ r'Remove-MpPreference -ControlledFolderAccessProtectedFolders "' + path + r'" 2>&1 | Write-Output ;' ]]
        [/#list]
        [#list avConfig.ControlledFolders.AllowedApps as app]
            [#local config_av += [ r'Add-MpPreference -ControlledFolderAccessAllowedApplications "' + app + r'" 2>&1 | Write-Output ;' ]]
            [#local unconfig_av += [ r'Remove-MpPreference -ControlledFolderAccessAllowedApplications "' + app + r'" 2>&1 | Write-Output ;' ]]
        [/#list]
        [#local config_av += [ r'Set-MpPreference -EnableControlledFolderAccess Enabled  2>&1 | Write-Output ;' ]]
        [#local unconfig_av += [ r'Set-MpPreference -EnableControlledFolderAccess Disabled  2>&1 | Write-Output ;' ]]
    [/#if]
    [#local config_av += [ 
        r"if(Test-Path -Path 'c:\ProgramData\Hamlet\Scripts\new_unconfig_av.ps1' -PathType Leaf) {",
        r"   if(Test-Path -Path 'c:\ProgramData\Hamlet\Scripts\unconfig_av.ps1' -PathType Leaf) {",
        r"      Remove-Item c:\ProgramData\Hamlet\Scripts\unconfig_av.ps1 ;",
        r"   }",
        r'   Rename-Item -Path "c:\ProgramData\Hamlet\Scripts\new_unconfig_av.ps1" -NewName "unconfig_av.ps1" 2>&1 | Write-Output ;',
        r"}"]]

    [#local content = {
            "files": {
                "c:\\ProgramData\\Hamlet\\Scripts\\av_tasks.ps1" : {
                    "content" : {
                        "Fn::Join" : [
                            "\n",
                            [
                                "Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\user-step.log -Append ;",
                                r'echo "AV Tasks - av_tasks.ps1" ;',
                                r"Update-MpSignature ;",
                                r"Stop-Transcript | out-null"
                            ]
                        ]
                    },
                    "mode" : "000755"
                },
                "c:\\ProgramData\\Hamlet\\Scripts\\schedule_tasks.ps1" : {
                    "content" : {
                        "Fn::Join" : [
                            "\n",
                            [
                                "Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\user-step.log -Append ;",
                                r'echo "Schedule Tasks - schedule_tasks.ps1" ;',
                                r"$avAction = New-ScheduledTaskAction `",
                                r"    -Execute 'powershell.exe' `",
                                r"    -Argument '-File c:\ProgramData\Hamlet\Scripts\av_tasks.ps1' 2>&1 | Write-Output ;",
                                r"$avTrigger = New-ScheduledTaskTrigger -Daily -At 3PM 2>&1 | Write-Output ;",
                                r"$taskName = 'avRefresh' ;",
                                r"$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName } ;",
                                r"if($taskExists) { Unregister-ScheduledTask -TaskName $taskName } ;",
                                r"$taskDesc = 'Refresh Windows Defender definition files' ;",
                                r"Register-ScheduledTask `",
                                r"    -TaskName $taskName `",
                                r"    -Action $avAction `",
                                r"    -Trigger $avTrigger `",
                                r"    -Description $taskDesc 2>&1 | Write-Output ;",
                                r"Stop-Transcript | out-null"
                            ]
                        ]
                    },
                    "mode" : "000755"
                },
                "c:\\ProgramData\\Hamlet\\Scripts\\config_av.ps1" : {
                    "content" : {
                        "Fn::Join" : [
                            "\n",
                            [
                                "Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\user-step.log -Append ;",
                                r'echo "Config AntiVirus - config_av.ps1" ;'
                            ] + config_av + [
                                r"Stop-Transcript | out-null"
                            ]
                        ]
                    },
                    "mode" : "000755"
                },
                "c:\\ProgramData\\Hamlet\\Scripts\\new_unconfig_av.ps1" : {
                    "content" : {
                        "Fn::Join" : [
                            "\n",
                            [
                                "Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\user-step.log -Append ;",
                                r'echo "Config AntiVirus - unconfig_av.ps1" ;'
                            ] + unconfig_av + [
                                r"Stop-Transcript | out-null"
                            ]
                        ]
                    },
                    "mode" : "000755"
                }
            },
            "commands": {
                "InitialUpdate" : {
                    "command" : "powershell.exe -ExecutionPolicy Bypass -Command c:\\ProgramData\\Hamlet\\Scripts\\schedule_tasks.ps1",
                    "ignoreErrors" : false
                },
                "ConfigAV" : {
                    "command" : "powershell.exe -ExecutionPolicy Bypass -Command c:\\ProgramData\\Hamlet\\Scripts\\config_av.ps1",
                    "ignoreErrors" : false
                }
            }
        }]

    [@computeTaskConfigSection
        computeTaskTypes=[ COMPUTE_TASK_ANTIVIRUS_CONFIG ]
        id="WinDefenderAntivirus"
        priority=1
        engine=AWS_EC2_CFN_INIT_COMPUTE_TASK_CONFIG_TYPE
        content=content
    /]
[/#macro]
