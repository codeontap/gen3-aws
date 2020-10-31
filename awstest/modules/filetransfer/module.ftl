[#ftl]

[@addModule
    name="filetransfer"
    description="Testing module for the aws filetransfer component"
    provider=AWSTEST_PROVIDER
    properties=[]
/]

[#macro awstest_module_filetransfer  ]

    [#-- Base SFTP File Transfer Server --]
    [@loadModule
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "filetransferbase" : {
                            "filetransfer" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : ["aws-filetransfer-base"]
                                    }
                                },
                                "Protocols" : [ "sftp" ],
                                "Profiles" : {
                                    "Testing" : [ "filetransferbase" ]
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "filetransferbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "CFN" : {
                            "Resource" : {
                                "transferServer" : {
                                    "Name" : "transferServerXappXfiletransferbase",
                                    "Type" : "AWS::Transfer::Server"
                                },
                                "securityGroup" : {
                                    "Name" : "securityGroupXtransferServerXappXfiletransferbase",
                                    "Type" : "AWS::EC2::SecurityGroup"
                                }
                            },
                            "Output" : [
                                "transferServerXappXfiletransferbase",
                                "transferServerXappXfiletransferbaseXarn",
                                "transferServerXappXfiletransferbaseXname"
                            ]
                        }
                    }
                }
            },
            "TestProfiles" : {
                "filetransferbase" : {
                    "filetransfer" : {
                        "TestCases" : [ "filetransferbase" ]
                    }
                }
            }
        }
    /]
[/#macro]
