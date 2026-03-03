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

  resource_group_name = "rg-hub-prod"
  location            = "Central India"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Hub"
  }
}
