terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

  backend "azurerm" {
    resource_group_name  = "prod-rg"
    storage_account_name = "tfazinfrastr"
    container_name       = "tfstate"
    key                  = "uat/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = false
}
