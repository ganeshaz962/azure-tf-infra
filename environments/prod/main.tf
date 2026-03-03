terraform {
  backend "azurerm" {}
}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.rg_name
  location = var.location
}

module "storage_account" {
  source              = "../../modules/storage_account"
  name                = var.sa_name
  resource_group_name = module.resource_group.name
  location            = var.location
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = module.resource_group.name
}
