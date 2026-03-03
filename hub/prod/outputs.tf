output "resource_group_id" {
  description = "The ID of the resource group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.resource_group_name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.virtual_network.vnet_id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.virtual_network.vnet_name
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = module.virtual_network.vnet_address_space
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = module.virtual_network.subnet_ids
}

output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value       = module.virtual_network.nsg_ids
}

