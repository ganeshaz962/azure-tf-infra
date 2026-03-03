# Security Best Practices

## VM Credential Management

### DO NOT store passwords in terraform.tfvars
Never commit plain-text passwords to version control. Instead, use one of these approaches:

#### Option 1: Azure Key Vault (Recommended)
```hcl
# Get password from Key Vault
data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.main.id
}
```

#### Option 2: Environment Variables
```bash
export TF_VAR_admin_password="YourSecurePassword123!"
terraform apply
```

#### Option 3: Terraform Variables File (Don't commit)
```bash
# Create .secrets.tfvars (add to .gitignore)
echo "admin_password = \"YourSecurePassword123!\"" > .secrets.tfvars

# Use during apply
terraform apply -var-file=.secrets.tfvars
```

#### Option 4: GitHub Secrets (For CI/CD)
```yaml
# In GitHub Actions workflow
- name: Apply Terraform
  env:
    TF_VAR_admin_password: ${{ secrets.TERRAFORMVM_PASSWORD }}
  run: terraform apply -auto-approve
```

## Network Security

### NSG Rules
Current NSG rules allow:
- HTTP (80)
- HTTPS (443)
- RDP (3389)

**Restrict access:**
```hcl
# Instead of "*" source, specify allowed IPs
source_address_prefix = "203.0.113.0/24"  # Your corporate IP range
```

### Application Gateway
- Always use HTTPS in production
- Implement WAF (Web Application Firewall)
- Use SSL/TLS certificates

## Access Control

### Azure RBAC
Assign minimal required roles:

```bash
# Contributor role (use for testing only)
az role assignment create \
  --assignee <service-principal-id> \
  --role Contributor \
  --scope /subscriptions/<subscription-id>

# Better: Assign specific roles
az role assignment create \
  --assignee <service-principal-id> \
  --role "Virtual Machine Contributor" \
  --scope /subscriptions/<subscription-id>
```

## Sensitive Data

### Terraform Outputs
Sensitive outputs are marked but still visible in state:

```hcl
output "admin_password" {
  value     = var.admin_password
  sensitive = true
}
```

### State File Protection
1. Enable Azure Storage encryption
2. Use managed encryption keys
3. Enable versioning
4. Implement SAS token expiration
5. Restrict network access

```bash
# Enable firewall on storage account
az storage account update \
  --name <storage-account-name> \
  --resource-group <resource-group> \
  --default-action Deny
```

## Monitoring & Auditing

### Enable Diagnostics
```hcl
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name               = "vm-diagnostics"
  target_resource_id = azurerm_windows_virtual_machine.vm.id
  
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}
```

### Azure Policy
Enforce compliance:
```bash
# List available built-in policies
az policy definition list --query "[].{name:name, description:description}" | head -20

# Assign policy
az policy assignment create \
  --name enforce-tls \
  --policy "require-ssl"
```

## Encryption

### Disk Encryption
```hcl
# Enable disk encryption
os_disk {
  caching              = "ReadWrite"
  storage_account_type = "Premium_LRS"
}

# Add Azure Disk Encryption
resource "azurerm_virtual_machine_extension" "disk_encryption" {
  name                 = "DiskEncryption"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"
}
```

## GitHub Actions Security

### Workflow Permissions
```yaml
permissions:
  contents: read
  pull-requests: read
  issues: write
  actions: read
```

### Secrets Rotation
```bash
# Update Service Principal password monthly
az ad sp credential reset \
  --name terraform-github-actions \
  --append
```

### Audit Logs
- Monitor GitHub Actions logs
- Review resource deployments in Azure
- Set up alerts for failed deployments

## Compliance

### Tags for Compliance
```hcl
tags = {
  Environment      = "production"
  Owner            = "DevOps Team"
  CostCenter       = "IT"
  DataClassification = "Confidential"
  BackupRequired   = "true"
  ComplianceScope  = "PCI-DSS"
}
```

### Regular Audits
1. Review NSG rules monthly
2. Audit VM access logs
3. Check Key Vault access
4. Monitor admin account usage

## Incident Response

### Password Reset Procedure
```bash
# If VM password is compromised
az vm user update \
  --resource-group <rg-name> \
  --name <vm-name> \
  --username azureuser \
  --password NewSecurePassword123!
```

### Emergency Access
```bash
# Reset admin password via Azure Portal:
# VM > Reset password > New password > Update
```

## Resources

- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [Terraform Security](https://www.terraform.io/docs/cloud/security/index.html)
- [Azure Key Vault Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret)
- [NSG Security Rules](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
