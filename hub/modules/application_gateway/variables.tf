variable "app_gateway_name" {
  description = "Name of the application gateway"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_gateway_pip_name" {
  description = "Name of the public IP for application gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name of the application gateway"
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "SKU tier of the application gateway"
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "Capacity of the application gateway"
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "ID of the subnet where application gateway will be deployed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
