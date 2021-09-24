[#ftl]

[@addExtension
    id="computetask_awswin_cfninit_wait"
    aliases=[
        "_computetask_awswin_cfninit_wait",
        "_computetask_awswin_cfninit"
    ]
    description=[
        "Updates and runs the cfn init process based on the provided cfninit metadata",
        "Runs a secondary cfninit once the create signal is sent"
    ]
    supportedTypes=[
        EC2_COMPONENT_TYPE
    ]
    scopes=[
        COMPUTETASK_EXTENSION_SCOPE
    ]
/]

[#macro shared_extension_computetask_awswin_cfninit_wait_deployment_computetask occurrence ]

    [#local computeResourceId = (_context.ComputeResourceId)!""]
    [#local waitHandleId      = (_context.WaitHandleId)!""]

    [#local waitConfigSetName = formatName(computeResourceId, "wait")]

    [#if ! waitHandleId?has_content ]
        [@fatal
            message="Missing waitHandle Id for second pass configuration"
            detail="Create a Wait Handler and Wait conditition and update the context with WaitHandleId as the resource id"
        /]
    [/#if]

    [@computeTaskConfigSection
        computeTaskTypes=[
            COMPUTE_TASK_RUN_STARTUP_CONFIG,
            COMPUTE_TASK_AWS_CFN_SIGNAL,
            COMPUTE_TASK_AWS_CFN_WAIT_SIGNAL
        ]
        id="CFNInit"
        priority=0
        engine=AWS_EC2_USERDATA_COMPUTE_TASK_CONFIG_TYPE
        content=[
            r"<powershell>",
            "# 'Create logging dir for cfninit scripts' ;",
            "Start-Transcript -Path c:\\ProgramData\\Hamlet\\Logs\\user-data.log -Append ;",
            "echo 'Create staging dirs for cfninit scripts' ;",
            "mkdir c:\\ProgramData\\Hamlet\\Scripts ;",
            "mkdir c:\\Temp ;",
            "mkdir c:\\ProgramData\\Amazon\\AmazonCloudWatchAgent ;",
            "echo 'Remainder of configuration via metadata' ;",
            {
                "Fn::Sub" : [
                    r'cfn-init.exe -v --stack ${StackName} --resource ${Resource} --region ${Region} --configset ${ConfigSet} 2>&1 | Write-Output ',
                    {
                        "StackName" : { "Ref" : "AWS::StackName" },
                        "Region" : { "Ref" : "AWS::Region" },
                        "Resource" : computeResourceId,
                        "ConfigSet" : computeResourceId
                    }
                ]
            },
            ";",
            {
                "Fn::Sub" : [
                    r'cfn-signal.exe -e $lastexitcode --stack ${StackName} --resource ${Resource} --region ${Region} 2>&1 | Write-Output ',
                    {
                        "StackName" : { "Ref" : "AWS::StackName" },
                        "Region" : { "Ref" : "AWS::Region" },
                        "Resource" : computeResourceId
                    }
                ]
            },
            ";",
            {
                "Fn::Sub" : [
                    r'cfn-init.exe -v --stack ${StackName} --resource ${Resource} --region ${Region} --configset ${WaitConfigSet} 2>&1 | Write-Output ',
                    {
                        "StackName" : { "Ref" : "AWS::StackName" },
                        "Region" : { "Ref" : "AWS::Region" },
                        "Resource" : computeResourceId,
                        "WaitConfigSet" : waitConfigSetName
                    }
                ]
            },
            ";",
            {
                "Fn::Sub" : [
                    r"cfn-signal.exe -e $lastexitcode '${WaitHandleUrl}'  2>&1 | Write-Output",
                    {
                        "WaitHandleUrl" : getReference(waitHandleId)
                    }
                ]
            },
            r"</powershell>"
        ]
    /]

    [@computeTaskConfigSection
        computeTaskTypes=[ COMPUTE_TASK_AWS_CLI ]
        id="CFNHup"
        priority=1
        engine=AWS_EC2_CFN_INIT_COMPUTE_TASK_CONFIG_TYPE
        content={
            "files": {
                "c:\\cfn\\cfn-hup.conf" : {
                    "content" : { "Fn::Join" : ["", [
                    "[main]\n",
                    "stack=", { "Ref" : "AWS::StackName" }, "\n",
                    "region=", { "Ref" : "AWS::Region" }, "\n"
                    ]]}
                },
                "c:\\cfn\\hooks.d\\cfn-auto-reloader.conf" : {
                    "content": { "Fn::Join" : ["", [
                    "[cfn-auto-reloader-hook]\n",
                    "triggers=post.update\n",
                    "path=Resources.",
                        computeResourceId,
                        ".Metadata.AWS::CloudFormation::Init\n",
                    "action=cfn-init.exe ",
                        " -v -s ", { "Ref" : "AWS::StackName" },
                        " -r ", computeResourceId,
                        " --configsets ", computeResourceId,
                        " --region ", { "Ref" : "AWS::Region" }, "\n"
                    ]]}
                }
            },
            "services" : {
                "windows" : {
                    "cfn-hup" : {
                        "enabled" : "true",
                        "ensureRunning" : "true",
                        "files" : ["c:\\cfn\\cfn-hup.conf", "c:\\cfn\\hooks.d\\cfn-auto-reloader.conf"]
                    }
                }
            }
        }
    /]

[/#macro]
