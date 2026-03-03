# Prod Environment Values
location            = "East US"
resource_group_name = "prod-rg"
environment         = "prod"

# VNet Configuration
vnet_name               = "prod-vnet"
vnet_address_space      = ["10.0.0.0/16"]
subnet_name             = "prod-subnet"
subnet_address_prefixes = ["10.0.1.0/24"]
nsg_name                = "prod-nsg"

# Application Gateway Configuration
app_gateway_name         = "prod-appgw"
app_gateway_pip_name     = "prod-appgw-pip"
app_gateway_sku_name     = "Standard_v2"
app_gateway_sku_tier     = "Standard_v2"
app_gateway_sku_capacity = 2

# Windows VM Configuration
vm_name         = "prod-winvm"
nic_name        = "prod-vm-nic"
vm_size         = "Standard_B2s"
admin_username  = "azureuser"
admin_password  = "Photon@12345"
os_disk_type    = "Premium_LRS"
image_publisher = "MicrosoftWindowsServer"
image_offer     = "WindowsServer"
image_sku       = "2019-Datacenter"
image_version   = "latest"

tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  CreatedDate = "2026-03-03"
}
