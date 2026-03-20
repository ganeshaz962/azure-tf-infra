variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-appgw-demo"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "appgw_subnet_prefix" {
  description = "CIDR prefix for the Application Gateway dedicated subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_subnet_prefix" {
  description = "CIDR prefix for the VM subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for the VM (must satisfy Azure complexity requirements)"
  type        = string
  sensitive   = true
  default     = "Photon@12345"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    managed_by  = "terraform"
  }
}
