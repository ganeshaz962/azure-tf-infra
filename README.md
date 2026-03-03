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

### Workflow Structure

**Reusable Workflow:** [deploy.yml](.github/workflows/deploy.yml)
- Contains terraform plan/approve/apply logic
- Called by environment-specific workflows

**Environment Workflows:**
- [terraform-hub-prod.yml](.github/workflows/terraform-hub-prod.yml) - Production
- [terraform-hub-uat.yml](.github/workflows/terraform-hub-uat.yml) - UAT

### Triggers

**On Pull Request:**
- Terraform plan runs
- Plan posted as PR comment
- No approval needed

**On Push to Main:**
- Only runs if files in that environment changed
- Terraform plan → Waits for approval → Terraform apply

**Manual Trigger:**
- Go to Actions → Select workflow → Run workflow
- Choose whether to apply changes

### Approval Process

1. **Make changes** in `hub/prod/` or `hub/uat/`
2. **Create PR** → Plan runs and posts comment
3. **Merge PR** → Workflow triggers automatically
4. **Approve** in Actions tab → Apply runs

**Smart Triggers:** Only affected environment runs!
- Change in `hub/prod/` → Only prod workflow runs
- Change in `hub/uat/` → Only uat workflow runs
- Change in `hub/module/` → Both workflows run

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