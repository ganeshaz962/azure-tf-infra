output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "List of subnet names"
  value       = [for subnet in azurerm_subnet.subnets : subnet.name]
}

output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}
