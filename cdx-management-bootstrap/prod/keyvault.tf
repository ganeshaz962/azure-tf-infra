resource "azurerm_key_vault" "kv" {
  name                      = "cdx-ganesh-management-kv"
  location                  = data.azurerm_resource_group.rg.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  purge_protection_enabled  = true
  rbac_authorization_enabled = true

  tenant_id = data.azurerm_subscription.primary.tenant_id
  sku_name  = "standard"
}

resource "azurerm_role_assignment" "kv_contributor" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.cdx_ganesh.object_id
}

# Grant the identity running Terraform access to manage KV secrets
resource "azurerm_role_assignment" "kv_terraform_caller" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
