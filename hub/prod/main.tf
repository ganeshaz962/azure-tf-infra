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
      service_endpoints = [
        "Microsoft.Storage",
        "Microsoft.Sql"
      ]
      create_nsg = true
    },
    {
      name             = "subnet-data"
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = [
        "Microsoft.Storage",
        "Microsoft.Sql"
      ]
      create_nsg = true
    },
    {
      name             = "subnet-web"
      address_prefixes = ["10.0.3.0/24"]
      service_endpoints = [
        "Microsoft.Storage"
      ]
      create_nsg = true
    },
    {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.4.0/26"]
      service_endpoints = []
      create_nsg       = false
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Hub"
    Name        = "Ganesh"
  }
}
