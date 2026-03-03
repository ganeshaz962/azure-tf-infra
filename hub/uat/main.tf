resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Virtual Network Module
module "vnet" {
  source = "../modules/vnet"

  vnet_name               = var.vnet_name
  address_space           = var.vnet_address_space
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  nsg_name                = var.nsg_name

  tags = var.tags
}

# Application Gateway Module
module "app_gateway" {
  source = "../modules/application_gateway"

  app_gateway_name      = var.app_gateway_name
  app_gateway_pip_name  = var.app_gateway_pip_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  subnet_id             = module.vnet.subnet_id
  sku_name              = var.app_gateway_sku_name
  sku_tier              = var.app_gateway_sku_tier
  sku_capacity          = var.app_gateway_sku_capacity

  tags = var.tags
}

# Windows VM Module
module "windows_vm" {
  source = "../modules/windows_vm"

  vm_name             = var.vm_name
  nic_name            = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet.subnet_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  nsg_id              = module.vnet.nsg_id
  os_disk_type        = var.os_disk_type
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  image_version       = var.image_version

  tags = var.tags
}
