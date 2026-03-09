data "azuread_group" "cdx_ganesh" {
  display_name     = "cdx-ganesh"
  security_enabled = true
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "rg" {
  name = "management-rg"
}

data "azurerm_storage_account" "tfstate" {
  name                = "tfstateganeshcdx"
  resource_group_name = data.azurerm_resource_group.rg.name
}
