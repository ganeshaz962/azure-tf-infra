output "resource_group_name" {
  description = "Name of the deployed resource group"
  value       = azurerm_resource_group.rg.name
}

output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}

output "application_urls" {
  description = "HTTP URLs for each of the 5 path-based applications"
  value = {
    app1 = "http://${azurerm_public_ip.appgw_pip.ip_address}/app1/"
    app2 = "http://${azurerm_public_ip.appgw_pip.ip_address}/app2/"
    app3 = "http://${azurerm_public_ip.appgw_pip.ip_address}/app3/"
    app4 = "http://${azurerm_public_ip.appgw_pip.ip_address}/app4/"
    app5 = "http://${azurerm_public_ip.appgw_pip.ip_address}/app5/"
  }
}

output "vm_private_ip" {
  description = "Private IP of the VM (not directly reachable from outside the VNet)"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vnet_id" {
  description = "Resource ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}
