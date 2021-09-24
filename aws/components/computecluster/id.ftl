[#ftl]
[@addResourceGroupInformation
    type=COMPUTECLUSTER_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "AntiVirus",
            "AttributeSet" : AWS_ANTIVIRUS_ATTRIBUTESET_TYPE
        }
    ]
    provider=AWS_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AWS_CLOUDWATCH_SERVICE,
            AWS_ELASTIC_COMPUTE_SERVICE,
            AWS_IDENTITY_SERVICE,
            AWS_VIRTUAL_PRIVATE_CLOUD_SERVICE,
            AWS_AUTOSCALING_SERVICE,
            AWS_KEY_MANAGEMENT_SERVICE,
            AWS_SYSTEMS_MANAGER_SERVICE
        ]
/]

[@addResourceGroupAttributeValues
    type=COMPUTECLUSTER_COMPONENT_TYPE
    provider=AWS_PROVIDER
    extensions=[
        {
            "Names" : "ComputeInstance",
            "Children" : [
                {
                    "Names" : "OperatingSystem",
                    "AttributeSet" : AWS_OPERATINGSYSTEM_ATTRIBUTESET_TYPE
                },
                {
                    "Names" : "Image",
                    "AttributeSet" : AWS_COMPUTEIMAGE_ATTRIBUTESET_TYPE
                },
                {
                    "Names" : "ComputeTasks",
                    "Description" : "Customisation to setup the compute instance from its image",
                    "Children" : [
                        {
                            "Names" : "Extensions",
                            "Default" : [
                                "_computetask_awslinux_cfninit_asg",
                                "_computetask_linux_hamletenv",
                                "_computetask_linux_volumemount",
                                "_computetask_awslinux_ospatching",
                                "_computetask_linux_filedir",
                                "_computetask_linux_sshkeys",
                                "_computetask_awscli",
                                "_computetask_awslinux_cwlog",
                                "_computetask_awslinux_efsmount",
                                "_computetask_linux_userbootstrap",
                                "_computetask_linux_scriptsdeployment",
                                "_computetask_awslinux_vpc_lb"
                            ]
                        }
                    ]
                }
            ]
        }
    ]
/]
