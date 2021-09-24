[#ftl]

[@addExtension
    id="computetask_awslinux_cfninit_asg"
    aliases=[
        "_computetask_awslinux_cfninit_asg"
    ]
    description=[
        "Updates and runs the cfn init process based on the provided cfninit metadata and sends startup lifecycle event notification"
    ]
    supportedTypes=[
        ECS_COMPONENT_TYPE,
        COMPUTECLUSTER_COMPONENT_TYPE,
        BASTION_COMPONENT_TYPE
    ]
    scopes=[
        COMPUTETASK_EXTENSION_SCOPE
    ]
/]

[#macro shared_extension_computetask_awslinux_cfninit_asg_deployment_computetask occurrence ]

    [#local computeResourceId = (_context.ComputeResourceId)!"" ]

    [@computeTaskConfigSection
        computeTaskTypes=[
            COMPUTE_TASK_RUN_STARTUP_CONFIG,
            COMPUTE_TASK_AWS_CFN_SIGNAL,
            COMPUTE_TASK_AWS_ASG_STARTUP_SIGNAL
        ]
        id="CFNInitASG"
        priority=0
        engine=AWS_EC2_USERDATA_COMPUTE_TASK_CONFIG_TYPE
        content=[
            r'#!/bin/bash',
            r'set -uo pipefail',
            "exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1",
            "# Update cfn bootstrap commands",
            "yum install -y aws-cfn-bootstrap",
            "# Create staging dirs for cfninit scripts",
            "mkdir -p /var/log/hamlet_cfninit/",
            "mkdir -p /opt/hamlet_cfninit/",
            "# Remainder of configuration via metadata",
            {
                "Fn::Sub" : [
                    r'/opt/aws/bin/cfn-init -v --stack ${StackName} --resource ${Resource} --region ${Region} --configset ${ConfigSet}',
                    {
                        "StackName" : { "Ref" : "AWS::StackName" },
                        "Region" : { "Ref" : "AWS::Region" },
                        "Resource" : computeResourceId,
                        "ConfigSet" : computeResourceId
                    }
                ]
            },
            r'init_status=$?',
            "# Signal the status from cfn-init",
            {
                "Fn::Sub" : [
                    r'/opt/aws/bin/cfn-signal -e ${!init_status} --stack ${StackName} --resource ${Resource} --region ${Region}',
                    {
                        "StackName" : { "Ref" : "AWS::StackName" },
                        "Region" : { "Ref" : "AWS::Region" },
                        "Resource" : computeResourceId
                    }
                ]
            },
            r'# Signal the status to the ASG',
            r'instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"',
            {
                "Fn::Sub" : [
                    r'asg_name="$(aws --region ${Region} autoscaling describe-auto-scaling-instances --instance-ids "${!instance_id}" --query "AutoScalingInstances[0].AutoScalingGroupName" --output text)"',
                    {
                        "Region" : { "Ref" : "AWS::Region" }
                    }
                ]
            },
            r'if [[ "${init_status}" == "0" ]]; then',
            r'   echo "init process successful"',
            r'   asg_result="CONTINUE"',
            r'else',
            r'   echo "init process failed"',
            r'   asg_result="ABANDON"',
            r'fi',
            {
                "Fn::Sub" : [
                    r'aws --region ${Region} autoscaling complete-lifecycle-action  --lifecycle-hook-name ${HookName} --auto-scaling-group-name ${!asg_name} --instance-id ${!instance_id} --lifecycle-action-result ${!asg_result}'
                    {
                        "Region" : { "Ref" : "AWS::Region" },
                        "HookName" : computeResourceId
                    }
                ]
            }
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
