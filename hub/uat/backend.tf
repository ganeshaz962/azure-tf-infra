terraform {
  backend "azurerm" {
    resource_group_name  = "rg-hub-uat"
    storage_account_name = "tfazinfrastatstr"
    container_name       = "state"
    key                  = "hub-uat.tfstate"
  }
}
