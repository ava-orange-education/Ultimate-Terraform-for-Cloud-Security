resource "azurerm_policy_definition" "fedramp_policy" {  
  name         = "fedramp-encryption-policy"  
  policy_type  = "Custom"  
  mode         = "All"  

  policy_rule = jsonencode({  
    if = {  
      field = "Microsoft.Storage/storageAccounts/encryption.requireInfrastructureEncryption"  
      equals = "false"  
    }  
    then = {  
      effect = "Deny"  
    }  
  })  
}  
