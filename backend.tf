terraform {
  backend "azurerm" {
    resource_group_name  = "rg-appgw-demo"
    storage_account_name = "tfstateinfraganesh"
    container_name       = "tfstate"
    key                  = "appgw/terraform.tfstate"
    use_oidc             = true
  }
}