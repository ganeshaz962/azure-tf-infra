#--------------------------------------------------------------
# Network Interface – static private IP
# cidrhost() computes the 4th host address (.4) in the subnet,
# which is the first usable IP after Azure's reserved addresses.
#--------------------------------------------------------------
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-vm-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "dynamic"
    private_ip_address            = cidrhost(var.vm_subnet_prefix, 4)
  }
}

#--------------------------------------------------------------
# Linux Virtual Machine – Ubuntu 22.04 LTS
#--------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-appgw-demo"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  tags                            = var.tags

  os_disk {
    name                 = "osdisk-vm-demo"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Azure stores the password as a write-only value; it is never returned by the API.
  # Without ignore_changes, any plan run with a different TF_VAR_vm_admin_password
  # value (even the same password) would force a VM replacement. Ignoring it here
  # prevents that while still allowing the initial password to be set on creation.
  lifecycle {
    ignore_changes = [admin_password]
  }
}

#--------------------------------------------------------------
# Custom Script Extension
# Installs Nginx and configures 5 path-based virtual locations:
#   /app1/  /app2/  /app3/  /app4/  /app5/
# The script is base64-encoded and sent inline (no external URL).
#--------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "nginx_setup" {
  name                 = "nginx-setup"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  tags                 = var.tags

  settings = jsonencode({
    script = base64encode(file("${path.module}/scripts/vm-setup.sh"))
  })
}
