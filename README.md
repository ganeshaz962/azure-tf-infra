# Azure Infrastructure with Terraform

This repository manages Azure infrastructure using Terraform with automated deployment via GitHub Actions.

## 🚀 Quick Setup

### Step 1: Add Azure Secrets
Go to **Settings** → **Secrets** → **Actions** → Add:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

### Step 2: Create Environments
Go to **Settings** → **Environments** → Create two:

**`prod`**
- Check **Required reviewers** → Add your username
- Save

**`uat`**
- Check **Required reviewers** → Add your username
- Save

### Step 3: Enable Branch Protection
Go to **Settings** → **Branches** → Add rule for `main`:
- ✅ Require pull request
- ✅ Require 1 approval

Done! You're ready to deploy.

## How It Works

### Simple 2-Step Approval Process

**Step 1: Pull Request (Review Changes)**
```
1. Create branch and make changes
2. Push and create PR
3. Terraform plan runs automatically
4. Review plan in PR comments
5. Approve and merge PR
```

**Step 2: Deployment (Approve Apply)**
```
1. After merge, workflow runs
2. Terraform plan runs for prod and uat
3. Go to Actions tab → Click workflow
4. Click "Review deployments"
5. Select prod/uat and approve
6. Resources get created/updated
```

### What Happens When?

**On PR:** 
- Terraform plan only (no changes to Azure)
- Plan results posted as comment

**On merge to main:**
- Terraform plan runs
- Waits for your approval
- After approval: terraform apply creates resources

**For both environments:**
- First deployment: Approve both prod and uat
- Future changes: Approve only what changed

## Local Development

### Initialize Terraform

```bash
cd hub/prod  # or hub/uat
terraform init
```

### Plan Changes

```bash
terraform plan
```

### Apply Changes

```bash
terraform apply
```

### Authenticate Locally

Set environment variables:

```powershell
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"
```

## Environments

### Production (`hub/prod`)
- Resource Group: `rg-hub-prod`
- Location: East US
- Environment Tag: Production

### UAT (`hub/uat`)
- Resource Group: `rg-hub-uat`
- Location: East US
- Environment Tag: UAT

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request
4. Terraform plan will run automatically
5. After approval and merge, changes will be applied automatically
Folder Structure

```
hub/
├── module/resource-group/    # Reusable Terraform module
├── prod/                     # Production config
└── uat/                      # UAT config
```