# General Variables
variable "location" {
  description = "Azure region location"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "uat-rg"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "uat"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "uat"
    ManagedBy   = "Terraform"
  }
}

# VNet Variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "uat-vnet"
}

variable "vnet_address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "uat-subnet"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "uat-nsg"
}

# Application Gateway Variables
variable "app_gateway_name" {
  description = "Name of the application gateway"
  type        = string
  default     = "uat-appgw"
}

variable "app_gateway_pip_name" {
  description = "Name of the public IP for application gateway"
  type        = string
  default     = "uat-appgw-pip"
}

variable "app_gateway_sku_name" {
  description = "SKU name of the application gateway"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  description = "SKU tier of the application gateway"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_sku_capacity" {
  description = "Capacity of the application gateway"
  type        = number
  default     = 2
}

# Windows VM Variables
variable "vm_name" {
  description = "Name of the Windows virtual machine"
  type        = string
  default     = "uat-vm"
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "uat-nic"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  sensitive   = true
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  description = "Type of the OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "image_publisher" {
  description = "Publisher of the image"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Offer of the image"
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "SKU of the image"
  type        = string
  default     = "2019-Datacenter"
}

variable "image_version" {
  description = "Version of the image"
  type        = string
  default     = "latest"
}
