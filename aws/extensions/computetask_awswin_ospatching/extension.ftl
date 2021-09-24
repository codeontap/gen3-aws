[#ftl]

[@addExtension
    id="computetask_awswin_ospatching"
    aliases=[
        "_computetask_awswin_ospatching"
    ]
    description=[
        "Windows OS Patching Warning"
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

[#macro shared_extension_computetask_awswin_ospatching_deployment_computetask occurrence ]

    [#local OSPatching = _context.InstanceOSPatching ]
    [#local avConfig = occurrence.Configuration.Solution["aws:AntiVirus"]]

    [#if OSPatching.Enabled ]
        [@warning
            message="Non-AMI based patching of OS is not supported on Windows Server"
            context=OSPatching
        /]

        [#local content = {
            }]
    [#else]
        [#local content={}]
    [/#if]

    [@computeTaskConfigSection
        computeTaskTypes=[ COMPUTE_TASK_OS_SECURITY_PATCHING ]
        id="OSPatching"
        priority=1
        engine=AWS_EC2_CFN_INIT_COMPUTE_TASK_CONFIG_TYPE
        content=content
    /]
[/#macro]
