terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../module/resource-group"

  resource_group_name = "rg-hub-uat"
  location            = "Central India"

  tags = {
    Environment = "UAT"
    ManagedBy   = "Terraform"
    Project     = "Hub"
  }
}
