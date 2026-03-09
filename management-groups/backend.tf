terraform {
  backend "azurerm" {
    subscription_id      = "67874868-54bc-43f4-916a-5e23c3631ee3"
    resource_group_name  = "management-rg"
    storage_account_name = "sascdxprodtfstatesa"
    container_name       = "tfbackend"
    key                  = "infra/cdx-management/management-groups/terraform.state"
    tenant_id            = "5581c9a8-168b-45f0-abd4-d375da99bf9f"
    use_azuread_auth     = true
  }
}
