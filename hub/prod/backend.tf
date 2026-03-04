terraform {
  backend "azurerm" {
    resource_group_name  = "rg-hub-prod"
    storage_account_name = "tfazinfrastatstr"
    container_name       = "state"
    key                  = "hub-prod.tfstate"
  }
}
