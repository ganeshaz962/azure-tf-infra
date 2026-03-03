# UAT Environment Values
location            = "East US"
resource_group_name = "uat-rg"
environment         = "uat"

# VNet Configuration
vnet_name               = "uat-vnet"
vnet_address_space      = ["10.1.0.0/16"]
subnet_name             = "uat-subnet"
subnet_address_prefixes = ["10.1.1.0/24"]
nsg_name                = "uat-nsg"

# Application Gateway Configuration
app_gateway_name         = "uat-appgw"
app_gateway_pip_name     = "uat-appgw-pip"
app_gateway_sku_name     = "Standard_v2"
app_gateway_sku_tier     = "Standard_v2"
app_gateway_sku_capacity = 2

# Windows VM Configuration
vm_name         = "uat-winvm"
nic_name        = "uat-vm-nic"
vm_size         = "Standard_B2s"
admin_username  = "azureuser"
admin_password  = "JyL9qR3s!UAT@2026#SecurePass"
os_disk_type    = "Premium_LRS"
image_publisher = "MicrosoftWindowsServer"
image_offer     = "WindowsServer"
image_sku       = "2019-Datacenter"
image_version   = "latest"

tags = {
  Environment = "uat"
  ManagedBy   = "Terraform"
  CreatedDate = "2026-03-03"
}
