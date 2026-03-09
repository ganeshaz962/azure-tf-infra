
# Prod admin SP - Role through our AD group
resource "azuread_application" "cdx-ganesh-admin-sp" {
  display_name = "cdx-ganesh-admin-sp"
  owners       = data.azuread_group.cdx_ganesh.members

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9" # Application.ReadWrite.All
      type = "Role"
    }
  }

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal" "cdx-ganesh-demo-admin-sp" {
  client_id                    = azuread_application.cdx-ganesh-admin-sp.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_ganesh.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_group_member" "cdx-ganesh-admin-sp" {
  group_object_id  = data.azuread_group.cdx_ganesh.object_id
  member_object_id = azuread_service_principal.cdx-ganesh-demo-admin-sp.object_id
}

resource "azurerm_key_vault_secret" "cdx-prod-admin-sp-id" {
  name         = "cdx-prod-admin-sp-client-id"
  value        = azuread_application.cdx-ganesh-admin-sp.client_id
  key_vault_id = azurerm_key_vault.kv.id
}

/*
  Prod subscription creation - subscription roles - manual

  This SP should be used only for creation of CDX subscriptions and assignment in management groups
  graning permission to enrolement accounts is done manually with the following procedure:

  * https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/assign-roles-azure-service-principals

  * https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/enrollment-account-role-assignments/put

  Role assignments:

  Log in to the az CLI using the designated account (password can be found in 1password).

  | Scope   | az CLI account               | Billing account                                      |
  |---------|------------------------------|------------------------------------------------------|
  | sandbox | cdx-sandbox-azure@flysas.com | /billingAccounts/91882021/enrollmentAccounts/300853/ |
  | main    | cdx-azure@flysas.com         | /billingAccounts/91882021/enrollmentAccounts/302489/ |
  | test    | cdx-test-azure@flysas.com    | /billingAccounts/91882021/enrollmentAccounts/302490/ |

  Constructing the api json :

      cdx-platform-test: 302490
      cdx-main: 302489
      cdx-sandbox: 300853
      Object ID of cdx-prod-subscriptions-sp: 90681b82-0110-4788-8bf2-a71ed0d32570
      {
        "properties": {
          "principalId": "90681b82-0110-4788-8bf2-a71ed0d32570",
          "principalTenantId": "5581c9a8-168b-45f0-abd4-d375da99bf9f",
          "roleDefinitionId": "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/302490/billingRoleDefinitions/a0bcee42-bf30-4d1b-926a-48d21664ef71"
        }
      }

*/

/*resource "azuread_application" "cdx-prod-subscriptions-sp" {
  display_name = "cdx-prod-subscriptions-sp"
  owners       = data.azuread_group.cdx_developers.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal" "cdx-prod-subscriptions-sp" {
  client_id                    = azuread_application.cdx-prod-subscriptions-sp.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_developers.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

data "azurerm_management_group" "cdx" {
  name = "cdx"
}


resource "azuread_group_member" "cdx-prod-subscriptions-sp" {
  group_object_id  = data.azuread_group.cdx_developers.object_id
  member_object_id = azuread_service_principal.cdx-prod-subscriptions-sp.object_id
}

resource "azurerm_key_vault_secret" "cdx-prod-subscriptions-sp-id" {
  name         = "cdx-prod-subscriptions-sp-client-id"
  value        = azuread_application.cdx-prod-subscriptions-sp.client_id
  key_vault_id = azurerm_key_vault.kv.id
}


# DNS admin SP - Role through our AD group
resource "azuread_application" "cdx-dns-admin-sp" {
  display_name = "cdx-dns-admin-sp"
  owners       = data.azuread_group.cdx_developers.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal" "cdx-dns-admin-sp" {
  client_id                    = azuread_application.cdx-dns-admin-sp.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_developers.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azurerm_key_vault_secret" "cdx-dns-admin-sp-id" {
  name         = "cdx-dns-admin-sp-client-id"
  value        = azuread_application.cdx-dns-admin-sp.client_id
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_dns_zone" "flysas" {
  name                = "flysas.tech"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Give the group cdx-developer-admins permission to access terraform State without Access Key
# This group should include all team members, and SP's used for IaC
resource "azurerm_role_assignment" "tfstate-storage-blob-contrib" {
  scope                = data.azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.cdx_developers.object_id
}

# Prod adgroup SP - Role through our AD group
resource "azuread_application" "cdx-adgroup-admin-sp" {
  display_name = "cdx-adgroup-admin-sp"
  owners       = data.azuread_group.cdx_developers.members

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "dbaae8cf-10b5-4b86-a4a1-f871c94c6695" # Group.ReadWrite.All
      type = "Role"
    }
  }
  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal" "cdx-adgroup-admin-sp" {
  client_id                    = azuread_application.cdx-adgroup-admin-sp.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_developers.members

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azurerm_key_vault_secret" "cdx-adgroup-admin-sp-id" {
  name         = "cdx-adgroup-admin-sp-client-id"
  value        = azuread_application.cdx-adgroup-admin-sp.client_id
  key_vault_id = azurerm_key_vault.kv.id
}

# API Permission Automation SP - Role through our AD group
resource "azuread_application" "cdx-entra-admin-sp" {
  display_name = "cdx-entra-admin-sp"
  owners       = data.azuread_group.cdx_developers.members
}

resource "azuread_service_principal" "cdx-entra-admin-sp" {
  client_id                    = azuread_application.cdx-entra-admin-sp.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_developers.members
}

resource "azuread_group_member" "cdx-entra-admin-sp" {
  group_object_id  = data.azuread_group.cdx_developers.object_id
  member_object_id = azuread_service_principal.cdx-entra-admin-sp.object_id
}
resource "azurerm_key_vault_secret" "cdx-entra-admin-sp_id" {
  name         = "cdx-entra-admin-sp-client-id"
  value        = azuread_application.cdx-entra-admin-sp.client_id
  key_vault_id = azurerm_key_vault.kv.id
}

# Microsoft Graph API Service Principal
data "azuread_service_principal" "msgraph" {
  display_name = "Microsoft Graph"
}

# List of required app role names
locals {
  cdx_entra_admin_sp_permissions = [
    "AppRoleAssignment.ReadWrite.All",
    "Directory.ReadWrite.All"
  ]
}

# Assign all required app roles to the SP cdx_entra-admin-sp
resource "azuread_app_role_assignment" "cdx-entra-admin-sp_role_assignment" {
  for_each            = toset(local.cdx_entra_admin_sp_permissions)
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids[each.value]
  principal_object_id = azuread_service_principal.cdx-entra-admin-sp.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}*/
