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
    Name        = "Ganesh"
  }
}

module "virtual_network" {
  source = "../module/virtual-network"

  vnet_name           = "vnet-hub-prod"
  resource_group_name = module.resource_group.resource_group_name
  location            = "Central India"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []

  subnets = [
    {
      name             = "subnet-app"
      address_prefixes = ["10.0.1.0/24"]
    },
    {
      name             = "subnet-data"
      address_prefixes = ["10.0.2.0/24"]
    },
    {
      name             = "subnet-web"
      address_prefixes = ["10.0.3.0/24"]
    },
    {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.4.0/26"]
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Hub"
    Name        = "Ganesh"
  }
}

module "storage_account" {
  source = "../module/storage-account"

  storage_account_name     = "sthubprod001"
  resource_group_name      = module.resource_group.resource_group_name
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  containers = [
    {
      name        = "data"
      access_type = "private"
    },
    {
      name        = "logs"
      access_type = "private"
    },
    {
      name        = "backups"
      access_type = "private"
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Hub"
    Name        = "Ganesh"
  }
}

