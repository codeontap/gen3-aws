[#ftl]

[#function cwLogsPolicy actions logGroupName=""]
    [#local logGroupArn = logGroupName?has_content?then(
                    formatRegionalArn(
                            "logs",
                            "log-group:" + logGroupName + "*"),
                    "*"
                )]
    [#return
        [
            getPolicyStatement(
                actions,
                logGroupArn
            )
        ]
    ]

[/#function]

[#function cwLogsReadPermission logGroupName=""]
    [#return cwLogsPolicy(
        [
            "logs:GetLogEvents",
            "logs:GetLogGroupFields",
            "logs:GetLogRecord",
            "logs:StartQuery",
            "logs:FilterLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:DescribeQueries"
        ],
        logGroupName
    )]
[/#function]

[#function cwMetricsConsumePermission namespace="*"]
    [#return
        [
            getPolicyStatement(
                [
                    "cloudwatch:GetMetricData"
                ],
                "*",
                "",
                (namespace != "*" )?then(
                    {
                        "StringEquals" : {
                            "cloudwatch:namespace" : namespace
                        }
                    },
                    {}
                )
            )
        ]
    ]
[/#function]


[#function cwLogsProducePermission logGroupName="" ]
    [#return cwLogsPolicy(
        [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
        ],
        logGroupName
    )]
[/#function]

[#function cwMetricsProducePermission namespace="*"]
    [#return
        [
            getPolicyStatement(
                [
                    "cloudwatch:PutMetricData"
                ],
                "*",
                "",
                (namespace != "*" )?then(
                    {
                        "StringEquals" : {
                            "cloudwatch:namespace" : namespace
                        }
                    },
                    {}
                )
            )
        ]
    ]
[/#function]

[#function cwMetricsAllPermission namespace="*"]
    [#return
        cwLogsProducePermission(namespace) +
        cwLogsConsumePermission(namespace)
    ]
[/#function]

[#function cwLogsConfigurePermission ]
    [#return
        [
            getPolicyStatement(
                [
                    "logs:PutMetricFilter",
                    "logs:PutRetentionPolicy"
                ]
            )
        ]
    ]
[/#function]
