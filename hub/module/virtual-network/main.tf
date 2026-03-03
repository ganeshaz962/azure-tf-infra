resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes

  service_endpoints = lookup(each.value, "service_endpoints", [])
}

resource "azurerm_network_security_group" "nsg" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if lookup(subnet, "create_nsg", true) }

  name                = "nsg-${each.value.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if lookup(subnet, "create_nsg", true) }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
