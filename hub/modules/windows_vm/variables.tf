variable "vm_name" {
  description = "Name of the Windows virtual machine"
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

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
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
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "nsg_id" {
  description = "ID of the network security group"
  type        = string
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
