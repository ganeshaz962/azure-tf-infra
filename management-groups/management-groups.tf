resource "azurerm_management_group" "cdx" {
  display_name = "flysas"
  name         = "cdx"
}
resource "azurerm_management_group" "cdx-sandbox" {
  display_name               = "sandbox"
  parent_management_group_id = azurerm_management_group.cdx.id
  name                       = "cdx-sandbox"
}
resource "azurerm_management_group" "cdx-sandbox-team" {
  display_name               = "team"
  parent_management_group_id = azurerm_management_group.cdx-sandbox.id
  name                       = "cdx-sandbox-team"
}
resource "azurerm_management_group" "cdx-sandbox-personal" {
  display_name               = "personal"
  parent_management_group_id = azurerm_management_group.cdx-sandbox.id
  name                       = "cdx-sandbox-personal"
}
resource "azurerm_management_group" "cdx-decommissioned" {
  display_name               = "decommissioned"
  parent_management_group_id = azurerm_management_group.cdx.id
  name                       = "cdx-decommissioned"
}
resource "azurerm_management_group" "cdx-landing-zones" {
  display_name               = "landing-zones"
  parent_management_group_id = azurerm_management_group.cdx.id
  name                       = "cdx-landing-zones"
}
resource "azurerm_management_group" "cdx-landing-zones-online" {
  display_name               = "online"
  parent_management_group_id = azurerm_management_group.cdx-landing-zones.id
  name                       = "cdx-landing-zones-online"
}
resource "azurerm_management_group" "cdx-landing-zones-corp" {
  display_name               = "corp"
  parent_management_group_id = azurerm_management_group.cdx-landing-zones.id
  name                       = "cdx-landing-zones-corp"
}
resource "azurerm_management_group" "cdx-landing-zones-mgmt" {
  display_name               = "mgmt"
  parent_management_group_id = azurerm_management_group.cdx-landing-zones.id
  name                       = "cdx-landing-zones-mgmt"
}

resource "azurerm_management_group" "cdx-prod-platform" {
  display_name               = "platform"
  parent_management_group_id = azurerm_management_group.cdx.id
  name                       = "cdx-prod-platform"
}

resource "azurerm_management_group" "cdxtest" {
  display_name = "flysas-sandbox"
  name         = "cdxtest"
}
resource "azurerm_management_group" "cdx-test-sandbox" {
  display_name               = "sandbox"
  parent_management_group_id = azurerm_management_group.cdxtest.id
  name                       = "cdx-test-sandbox"
}
resource "azurerm_management_group" "cdx-test-sandbox-team" {
  display_name               = "team"
  parent_management_group_id = azurerm_management_group.cdx-test-sandbox.id
  name                       = "cdx-test-sandbox-team"
}
resource "azurerm_management_group" "cdx-test-sandbox-personal" {
  display_name               = "personal"
  parent_management_group_id = azurerm_management_group.cdx-test-sandbox.id
  name                       = "cdx-test-sandbox-personal"
}

resource "azurerm_management_group" "cdx-test-landing-zones" {
  display_name               = "landing-zones"
  parent_management_group_id = azurerm_management_group.cdxtest.id
  name                       = "cdx-test-landing-zones"
}
resource "azurerm_management_group" "cdx-test-landing-zones-online" {
  display_name               = "online"
  parent_management_group_id = azurerm_management_group.cdx-test-landing-zones.id
  name                       = "cdx-test-landing-zones-online"
}
resource "azurerm_management_group" "cdx-test-landing-zones-corp" {
  display_name               = "corp"
  parent_management_group_id = azurerm_management_group.cdx-test-landing-zones.id
  name                       = "cdx-test-landing-zones-corp"
}
resource "azurerm_management_group" "cdx-test-landing-zones-mgmt" {
  display_name               = "mgmt"
  parent_management_group_id = azurerm_management_group.cdx-test-landing-zones.id
  name                       = "cdx-test-landing-zones-mgmt"
}
resource "azurerm_management_group" "cdx-test-platform" {
  display_name               = "platform"
  parent_management_group_id = azurerm_management_group.cdxtest.id
  name                       = "cdx-test-platform"
}
