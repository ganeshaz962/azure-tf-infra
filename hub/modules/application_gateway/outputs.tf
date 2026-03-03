output "app_gateway_id" {
  description = "ID of the application gateway"
  value       = azurerm_application_gateway.app_gateway.id
}

output "app_gateway_name" {
  description = "Name of the application gateway"
  value       = azurerm_application_gateway.app_gateway.name
}

output "backend_address_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_application_gateway.app_gateway.backend_address_pool[0].id
}

output "public_ip_address" {
  description = "Public IP address of the application gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}
