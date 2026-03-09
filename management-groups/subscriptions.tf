resource "azurerm_subscription" "test_hub_subscription" {
  subscription_name = "cdx-test-hub-sandbox"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_test}"
  workload          = "DevTest"
  tags = {
    CostCenter         = "95426"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "cdx-developers"
    sandbox            = true
  }
}
resource "azurerm_management_group_subscription_association" "test_hub_subscription" {
  management_group_id = azurerm_management_group.cdx-test-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.test_hub_subscription.subscription_id}"
}
resource "azurerm_subscription" "test_management_subscription" {
  subscription_name = "cdx-test-management-sandbox"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_test}"
  workload          = "DevTest"
  tags = {
    CostCenter         = "95426"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "cdx-developers"
    sandbox            = true
  }
}
resource "azurerm_management_group_subscription_association" "test_management_subscription" {
  management_group_id = azurerm_management_group.cdx-test-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.test_management_subscription.subscription_id}"
}
resource "azurerm_subscription" "cdx-tools-test" {
  subscription_name = "cdx-tools-test"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_test}"
  tags = {
    CostCenter         = "90372"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "kubility-developers"
  }
}
resource "azurerm_management_group_subscription_association" "cdx-tools-test" {
  management_group_id = azurerm_management_group.cdx-prod-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.cdx-tools-test.subscription_id}"
}

resource "azurerm_subscription" "cdx-tools-prod" {
  subscription_name = "cdx-tools-prod"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_main}"
  tags = {
    CostCenter         = "90372"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "kubility-developers"
  }
}
resource "azurerm_management_group_subscription_association" "cdx-tools-prod" {
  management_group_id = azurerm_management_group.cdx-prod-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.cdx-tools-prod.subscription_id}"
}
resource "azurerm_subscription" "prod_hub_subscription" {
  subscription_name = "cdx-hub"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_main}"
  workload          = "Production"
  tags = {
    CostCenter         = "95426"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "cdx-developers"
  }
}
resource "azurerm_management_group_subscription_association" "prod_hub_subscription" {
  management_group_id = azurerm_management_group.cdx-prod-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.prod_hub_subscription.subscription_id}"
}
resource "azurerm_subscription" "prod_management_subscription" {
  subscription_name = "cdx-management"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_main}"
  workload          = "Production"
  tags = {
    CostCenter         = "95426"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "cdx-developers"
  }
}
resource "azurerm_management_group_subscription_association" "prod_management_subscription" {
  management_group_id = azurerm_management_group.cdx-prod-platform.id
  subscription_id     = "/subscriptions/${azurerm_subscription.prod_management_subscription.subscription_id}"
}
resource "azurerm_subscription" "adp-cdx-labs" {
  subscription_name = "adp-cdx-labs"
  billing_scope_id  = "/providers/Microsoft.Billing/billingAccounts/69584045/enrollmentAccounts/${local.enrollmentAccount_main}"
  workload          = "DevTest"
  tags = {
    CostCenter         = "95426"
    CreatedBy          = "terraform"
    ServiceId          = "IS084"
    Owners             = "sachin.gharge@sas.se, sayan.saha@sas.se"
    EmailNotifications = "cloudplatforms@sas.se"
    SlackNotifications = "talk-to-team-cloud-platform"
    "catalog.owner"    = "cdx-developers"
    sandbox            = true
  }
}
resource "azurerm_management_group_subscription_association" "adp-cdx-labs" {
  management_group_id = azurerm_management_group.cdx-landing-zones-corp.id
  subscription_id     = "/subscriptions/${azurerm_subscription.adp-cdx-labs.subscription_id}"
}

//code to move sas-loyaltysolutions subscription to cdx-landing-zones-corp management group

# Data source for the subscription to move
data "azurerm_subscription" "sas_loyalty_subscription" {
  subscription_id = "19cf7d53-df62-43b5-81ea-976c12b6f985"
}

# Resource to move the subscription
resource "azurerm_management_group_subscription_association" "sas_loyaltysolutions_infrastructure" {
  management_group_id = azurerm_management_group.cdx-landing-zones-corp.id
  subscription_id     = data.azurerm_subscription.sas_loyalty_subscription.id
}

# Data source for the subscription to move
data "azurerm_subscription" "sas_travel_subscription" {
  subscription_id = "0aac9f89-452a-492c-afd9-7e5b740e11b8"
}

# Resource to move the subscription
resource "azurerm_management_group_subscription_association" "sas_travel_subscription" {
  management_group_id = azurerm_management_group.cdx-landing-zones-corp.id
  subscription_id     = data.azurerm_subscription.sas_travel_subscription.id
}
