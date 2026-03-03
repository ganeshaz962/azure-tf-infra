variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "List of DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name               = string
    address_prefixes   = list(string)
    service_endpoints  = optional(list(string), [])
    create_nsg         = optional(bool, true)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
