resource "azurerm_resource_group" "rg" {
  name     = "management-rg"
  location = "Central India"
}

resource "azurerm_storage_account" "this" {
  name                      = "tfstateganeshcdx"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  https_traffic_only_enabled = true
  allow_nested_items_to_be_public  = false
  min_tls_version           = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }
  shared_access_key_enabled = true
}
resource "azurerm_storage_container" "this" {
  name                  = "tfbackend"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
