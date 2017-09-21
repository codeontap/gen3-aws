[#-- KMS CMK --]
[#if deploymentUnit?contains("cmk")]
    [#-- TODO: Get rid of inconsistent id usage --]
    [#assign cmkId = formatProductCMKTemplateId()]
    [#assign cmkAliasId = formatProductCMKAliasId(cmkId)]

    [@createCMK
        mode=productListMode
        id=cmkId
        description=productName
        statements=
            [
                getPolicyStatement(
                    "kms:*",
                    "*",
                    { 
                        "AWS": formatAccountPrincipalArn()
                    }
                )
            ]
        outputId=formatProductCMKId()
    /]
    
    [@createCMKAlias
        mode=productListMode
        id=cmkAliasId
        name="alias/" + productName
        cmkId=cmkId
    /]

[/#if]

