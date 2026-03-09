terraform {
  backend "azurerm" {
    storage_account_name = "tfstateganeshcdx"
    container_name       = "tfbackend"
    key                  = "infra/cdx-ganesh-management/bootstrap/terraform.state"
    subscription_id      = "e38f8e33-256d-4d93-8f4d-2c1816597713"
    tenant_id            = "6b93666e-6a54-4f14-a577-b6cec6095dd1"
    resource_group_name  = "management-rg"
    
  }
}
