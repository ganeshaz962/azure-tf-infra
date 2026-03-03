# GitHub Actions Setup Guide

This guide explains how to set up GitHub Actions for Terraform deployments to Azure.

## Prerequisites

- Active Azure Subscription
- GitHub Repository
- Azure CLI installed locally
- Permissions to create Service Principals in Azure AD

## Step 1: Create Azure Service Principal

Create a Service Principal for GitHub Actions to authenticate with Azure:

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create Service Principal
az ad sp create-for-rbac --name "terraform-github-actions" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

This command will output:
```json
{
  "appId": "xxxxx-xxxx-xxxx-xxxx-xxxxx",
  "displayName": "terraform-github-actions",
  "password": "xxxxx-xxxx-xxxx-xxxx-xxxxx",
  "tenant": "xxxxx-xxxx-xxxx-xxxx-xxxxx"
}
```

## Step 2: Create GitHub Secrets

In your GitHub repository, go to **Settings > Secrets and variables > Actions** and add:

1. **AZURE_SUBSCRIPTION_ID**
   - Value: Your Azure Subscription ID

2. **AZURE_CLIENT_ID**
   - Value: The `appId` from the Service Principal

3. **AZURE_CLIENT_SECRET**
   - Value: The `password` from the Service Principal

4. **AZURE_TENANT_ID**
   - Value: The `tenant` from the Service Principal

5. **AZURE_CREDENTIALS** (for Azure Login action)
   - Create JSON format:
   ```json
   {
     "clientId": "xxxxx-xxxx-xxxx-xxxx-xxxxx",
     "clientSecret": "xxxxx-xxxx-xxxx-xxxx-xxxxx",
     "subscriptionId": "xxxxx-xxxx-xxxx-xxxx-xxxxx",
     "tenantId": "xxxxx-xxxx-xxxx-xxxx-xxxxx"
   }
   ```

## Step 3: Configure Terraform Backend

### Create Storage Account for State Files

```bash
# Set variables
RESOURCE_GROUP="terraform-state-rg"
STORAGE_ACCOUNT="tfstateacct$(date +%s)"
LOCATION="East US"

# Create resource group
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --https-only true \
  --encryption-services blob

# Create container
az storage container create \
  --account-name $STORAGE_ACCOUNT \
  --name tfstate

# Enable versioning
az storage account blob-service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --enable-change-feed true \
  --enable-versioning true
```

### Update Provider Files

Update `hub/prod/provider.tf` and `hub/uat/provider.tf`:

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstateacct<timestamp>"
  container_name       = "tfstate"
  key                  = "prod/terraform.tfstate"  # or uat/terraform.tfstate
}
```

## Step 4: Initialize Terraform Locally

```bash
# For Production
cd hub/prod
terraform init

# For UAT
cd hub/uat
terraform init
```

## Step 5: Update terraform.tfvars

Update both `hub/prod/terraform.tfvars` and `hub/uat/terraform.tfvars` with your specific values:

```hcl
# Example for prod/terraform.tfvars
location            = "East US"
resource_group_name = "prod-rg"
environment         = "prod"

vnet_name               = "prod-vnet"
vnet_address_space      = ["10.0.0.0/16"]
subnet_name             = "prod-subnet"
subnet_address_prefixes = ["10.0.1.0/24"]
nsg_name                = "prod-nsg"

app_gateway_name         = "prod-appgw"
app_gateway_pip_name     = "prod-appgw-pip"
app_gateway_sku_name     = "Standard_v2"
app_gateway_sku_tier     = "Standard_v2"
app_gateway_sku_capacity = 2

vm_name         = "prod-winvm"
nic_name        = "prod-vm-nic"
vm_size         = "Standard_B2s"
admin_username  = "azureuser"
admin_password  = "YourSecurePassword123!"  # Use strong password
os_disk_type    = "Premium_LRS"

tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  CostCenter  = "IT"
}
```

## Step 6: Test GitHub Actions Workflow

1. Push changes to a feature branch:
   ```bash
   git checkout -b feature/terraform-setup
   git add .
   git commit -m "Add Terraform configuration"
   git push -u origin feature/terraform-setup
   ```

2. Create a Pull Request to main branch

3. GitHub Actions will automatically run `terraform plan` for both prod and uat

4. Review the plan output in the GitHub Actions logs

5. Merge to main branch to trigger `terraform apply`

## Troubleshooting

### Authentication Issues
```bash
# Verify Azure login locally
az login --service-principal -u <client-id> -p <client-secret> --tenant <tenant-id>

# Check subscriptions
az account list
```

### Backend Initialization Issues
```bash
# Check storage account access
az storage account show --name <storage-account-name> --resource-group <resource-group>

# Check container
az storage container exists --account-name <storage-account-name> --name tfstate
```

### GitHub Actions Secrets
- Verify all secrets are correctly set
- Use `echo` statements in workflows to debug (never print secrets)
- Check workflow logs for permission errors

## Best Practices

1. **Rotate Service Principal Credentials Regularly**
   ```bash
   az ad sp credential reset --name terraform-github-actions
   ```

2. **Use Azure Key Vault for Sensitive Values**
   - Store VM passwords in Key Vault
   - Reference them in Terraform via data sources

3. **Implement Approval Gates**
   - Require manual approval before applying to production
   - Use GitHub environments for this

4. **Monitor State File Access**
   - Enable Azure Storage Account logging
   - Review access logs regularly

5. **Implement Tagging Strategy**
   - Tag all resources for cost tracking
   - Use consistent naming conventions

## Additional Resources

- [GitHub Actions Azure Provider](https://github.com/azure/login)
- [Azure Terraform Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Backend Configuration](https://www.terraform.io/language/settings/backends/azurerm)
