resource "azurerm_role_definition" "custom_owner_roledefinition" {
  name        = "CustomOwner"
  scope       = "/providers/Microsoft.Management/managementGroups/5581c9a8-168b-45f0-abd4-d375da99bf9f"
  description = "A custom role that provides all the permissions of the built-in Owner role, except for write and delete actions on Microsoft.Security resources. This role is designed to restrict access to enabling or disabling advanced Cloud Security Posture Management (CSPM) features while allowing full control over other resources."

  permissions {
    actions = ["*"]
    not_actions = [
      "Microsoft.Security/pricings/write",
      "Microsoft.Security/pricings/delete",
      "Microsoft.Security/pricings/securityoperators/write",
      "Microsoft.Security/pricings/securityoperators/delete"
    ]
  }

  assignable_scopes = [
    "/providers/Microsoft.Management/managementGroups/5581c9a8-168b-45f0-abd4-d375da99bf9f"
  ]
}

resource "azurerm_role_definition" "custom_contributor_roledefinition" {
  name        = "CustomContributor"
  scope       = "/providers/Microsoft.Management/managementGroups/5581c9a8-168b-45f0-abd4-d375da99bf9f"
  description = "A custom role that provides all the permissions of the built-in Contibutor role, except for write and delete actions on Microsoft.Security resources. This role is designed to restrict access to enabling or disabling advanced Cloud Security Posture Management (CSPM) features while allowing full control over other resources same as Contibutor Role."

  permissions {
    actions = ["*"]
    not_actions = [
      "Microsoft.Authorization/*/Delete",
      "Microsoft.Authorization/*/Write",
      "Microsoft.Authorization/elevateAccess/Action",
      "Microsoft.Blueprint/blueprintAssignments/write",
      "Microsoft.Blueprint/blueprintAssignments/delete",
      "Microsoft.Compute/galleries/share/action",
      "Microsoft.Purview/consents/write",
      "Microsoft.Purview/consents/delete",
      "Microsoft.Resources/deploymentStacks/manageDenySetting/action",
      "Microsoft.Security/pricings/write",
      "Microsoft.Security/pricings/delete",
      "Microsoft.Security/pricings/securityoperators/write",
      "Microsoft.Security/pricings/securityoperators/delete"
    ]
  }

  assignable_scopes = [
    "/providers/Microsoft.Management/managementGroups/5581c9a8-168b-45f0-abd4-d375da99bf9f"
  ]
}
