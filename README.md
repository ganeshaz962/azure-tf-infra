# Azure Infrastructure as Code - Terraform Landing Zone

This repository contains Terraform configuration for deploying Azure infrastructure including Virtual Network, Application Gateway, and Windows Virtual Machines across multiple environments (Prod and UAT).

## Directory Structure

```
hub/
├── modules/
│   ├── vnet/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── application_gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── windows_vm/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── prod/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── outputs.tf
├── uat/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── outputs.tf
└── .github/workflows/
    └── terraform.yml
```

## Modules

### 1. VNet Module (`modules/vnet/`)
Creates a Virtual Network with:
- Azure Virtual Network
- Subnet
- Network Security Group (NSG) with rules for HTTP, HTTPS, and RDP

**Inputs:**
- `vnet_name`: Name of the virtual network
- `address_space`: Address space of the vnet (e.g., ["10.0.0.0/16"])
- `subnet_address_prefixes`: Subnet CIDR blocks
- `location`: Azure region
- `resource_group_name`: Resource group name

**Outputs:**
- `vnet_id`: Virtual Network ID
- `vnet_name`: Virtual Network name
- `subnet_id`: Subnet ID
- `nsg_id`: Network Security Group ID

### 2. Application Gateway Module (`modules/application_gateway/`)
Creates an Application Gateway with:
- Public IP address
- Application Gateway with basic HTTP routing
- Backend address pool
- HTTP settings and listeners

**Inputs:**
- `app_gateway_name`: Name of the application gateway
- `sku_name`: SKU name (default: Standard_v2)
- `sku_capacity`: Capacity/instance count (default: 2)
- `subnet_id`: Subnet ID where App Gateway will be deployed

**Outputs:**
- `app_gateway_id`: Application Gateway ID
- `public_ip_address`: Public IP address of the gateway
- `backend_address_pool_id`: Backend pool ID

### 3. Windows VM Module (`modules/windows_vm/`)
Creates a Windows Virtual Machine with:
- Network Interface Card (NIC)
- Windows Server 2019 VM
- Configurable username/password authentication

**Inputs:**
- `vm_name`: Name of the virtual machine
- `admin_username`: Admin username (sensitive)
- `admin_password`: Admin password (sensitive)
- `vm_size`: VM size (default: Standard_B2s)
- `subnet_id`: Subnet ID
- `nsg_id`: Network Security Group ID

**Outputs:**
- `vm_id`: Virtual Machine ID
- `private_ip_address`: Private IP of the VM
- `vm_name`: VM name

## Environments

### Production (prod/)
Full configuration for production environment with:
- Resource Group: `prod-rg`
- VNet CIDR: `10.0.0.0/16`
- Subnet CIDR: `10.0.1.0/24`
- VM: `prod-winvm` (Standard_B2s)

### UAT (uat/)
Full configuration for UAT environment with:
- Resource Group: `uat-rg`
- VNet CIDR: `10.1.0.0/16`
- Subnet CIDR: `10.1.1.0/24`
- VM: `uat-winvm` (Standard_B2s)

## Prerequisites

1. **Azure Subscription**: An active Azure subscription
2. **Terraform**: Version 1.0 or higher
3. **Azure CLI**: For authentication
4. **GitHub Secrets** (for CI/CD):
   - `AZURE_SUBSCRIPTION_ID`: Azure Subscription ID
   - `AZURE_CLIENT_ID`: Service Principal Client ID
   - `AZURE_CLIENT_SECRET`: Service Principal Secret
   - `AZURE_TENANT_ID`: Azure Tenant ID
   - `AZURE_CREDENTIALS`: JSON credentials for Azure Login action
   - `TERRAFORMVM_PASSWORD`: Secure VM password

## Setup Instructions

### 1. Update Backend Configuration

Update the backend configuration in `prod/provider.tf` and `uat/provider.tf`:

```hcl
backend "azurerm" {
  resource_group_name  = "your-rg-name"
  storage_account_name = "yourstorageaccount"
  container_name       = "tfstate"
  key                  = "prod/terraform.tfstate"  # or uat/terraform.tfstate
}
```

### 2. Update Terraform Variables

Modify `terraform.tfvars` files for each environment with your specific values:

```hcl
# prod/terraform.tfvars
location            = "East US"
resource_group_name = "prod-rg"
admin_password      = "YourSecurePassword123!"  # Update with secure password
```

### 3. Deploy Locally (Manual)

```bash
# Navigate to environment directory
cd hub/prod

# Initialize Terraform
terraform init

# Format check
terraform fmt -check -recursive

# Validate configuration
terraform validate

# Plan deployment
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```

### 4. Deploy via GitHub Actions (CI/CD)

The GitHub Actions workflow automatically:
1. Plans infrastructure for both prod and uat on every push/PR
2. Applies changes to main branch pushes only
3. Generates deployment summaries

**Required GitHub Secrets:**
```
AZURE_SUBSCRIPTION_ID
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_TENANT_ID
AZURE_CREDENTIALS (JSON format)
```

## Outputs

After deployment, Terraform will output:
```
resource_group_id: ID of the resource group
vnet_id: Virtual network ID
app_gateway_public_ip: Public IP of application gateway
vm_private_ip: Private IP of the Windows VM
vm_name: Name of the Windows VM
```

## Security Considerations

1. **Passwords**: Store VM passwords in Azure Key Vault and reference them via Terraform
2. **State File**: Use Azure Storage backend with encryption and access controls
3. **RBAC**: Implement least privilege access with Azure RBAC
4. **Secrets**: Use GitHub Secrets for sensitive credentials
5. **NSG Rules**: Review and restrict NSG rules as per security requirements

## Common Commands

```bash
# Validate config
terraform validate

# Format code
terraform fmt -recursive

# Check destruction plan
terraform plan -destroy

# Destroy resources
terraform destroy

# Output specific value
terraform output app_gateway_public_ip
```

## Troubleshooting

### Backend Configuration Issues
```bash
# Reinitialize backend
terraform init -reconfigure
```

### State Lock
```bash
# Unlock state (use with caution)
terraform force-unlock <LOCK_ID>
```

### Plan/Apply Failures
1. Check Azure credentials
2. Verify subscription access
3. Review resource quotas
4. Check region-specific resource availability

## Contributing

1. Create feature branch
2. Make changes and validate:
   - `terraform fmt`
   - `terraform validate`
   - `terraform plan`
3. Create pull request
4. Merge to main branch after approval

## Support

For issues or questions, please refer to:
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform Best Practices](https://docs.microsoft.com/en-us/azure/developer/terraform/)
