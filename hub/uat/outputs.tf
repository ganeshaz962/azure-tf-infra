output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.vnet.vnet_id
}

output "app_gateway_public_ip" {
  description = "Public IP address of the application gateway"
  value       = module.app_gateway.public_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the Windows VM"
  value       = module.windows_vm.private_ip_address
}

output "vm_name" {
  description = "Name of the Windows VM"
  value       = module.windows_vm.vm_name
}
