# Azure Infrastructure with Terraform

This repository contains Terraform configurations for managing Azure infrastructure using a modular approach with automated deployment via GitHub Actions.

## 🚀 Quick Start

### 1. Configure GitHub Secrets
Go to **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets:
- `AZURE_CLIENT_ID` - Service Principal Application ID
- `AZURE_CLIENT_SECRET` - Service Principal Secret
- `AZURE_SUBSCRIPTION_ID` - Azure Subscription ID
- `AZURE_TENANT_ID` - Azure Tenant ID

### 2. Setup Approval Environments
Go to **Settings** → **Environments** → **New environment**

Create two environments:

**Environment 1: `prod`**
- Enable **Required reviewers**
- Add production approvers
- Click **Save protection rules**

**Environment 2: `uat`**
- Enable **Required reviewers**
- Add UAT approvers (can be same or different people)
- Click **Save protection rules**

### 3. Enable Branch Protection (Recommended)
Go to **Settings** → **Branches** → **Add rule** for `main`

Enable:
- ✅ Require pull request before merging
- ✅ Require approvals (1+)

### 4. Make Your First Change
```bash
git checkout -b feature/test-change
# Make changes to terraform files
git add .
git commit -m "Test infrastructure change"
git push origin feature/test-change
# Create PR on GitHub
# Review terraform plan in PR comments
# Approve & merge PR
# Approve deployment in Actions tab when prompted
```

## Structure

```
hub/
├── module/
│   └── resource-group/    # Reusable resource group module
├── prod/                  # Production environment
└── uat/                   # UAT environment
```

## Prerequisites

- Terraform >= 1.0
- Azure Service Principal with required permissions
- GitHub repository secrets configured

## GitHub Secrets

The following secrets must be configured in your GitHub repository:

- `AZURE_CLIENT_ID` - Azure Service Principal Application ID
- `AZURE_CLIENT_SECRET` - Azure Service Principal Secret
- `AZURE_SUBSCRIPTION_ID` - Azure Subscription ID
- `AZURE_TENANT_ID` - Azure Tenant ID

## GitHub Actions Workflow

### Architecture

The workflow uses a **reusable workflow pattern** similar to enterprise setups:

**Main Workflow:** [deploy.yml](.github/workflows/deploy.yml)
- Calls the reusable workflow for each environment
- Passes configuration and secrets

**Reusable Workflow:** [reusable-terraform.yml](.github/workflows/reusable-terraform.yml)
- Contains the terraform plan/apply logic
- Can be reused for multiple environments
- Handles authentication and deployment

### Workflow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│  Developer makes changes in feature branch                  │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Create Pull Request                                        │
│  ├─ Terraform Plan runs automatically                       │
│  ├─ Plan posted as PR comment                               │
│  └─ [APPROVAL 1] Review & approve PR ✋                     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Merge to main branch                                       │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Main Branch Workflow                                       │
│  ├─ Terraform Plan runs                                     │
│  ├─ Waits at environment: "prod" and "uat"                  │
│  └─ [APPROVAL 2] Click "Review deployments" ✋              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Terraform Apply                                            │
│  ├─ Authenticates to Azure                                  │
│  ├─ Creates/updates resources                               │
│  └─ ✓ Infrastructure deployed                               │
└─────────────────────────────────────────────────────────────┘
```via reusable workflow
3. Workflow pauses at `requires_approval` environment
4. Go to **Actions** tab → Click on the workflow run
5. Click **Review deployments** button
6. **Select environment and approve** - Second approval checkpoint ✋
7*Stage 1: Pull Request Review (First Approval)**
1. Create a PR with your infrastructure changes
2. Terraform Plan runs automatically
3. Plan output is posted as a comment on the PR
4. **Review and approve the PR** - First approval checkpoint ✋
5. Merge to main branch

**Stage 2: Deployment Approval (Second Approval)**
1. After PR is merged to main
2. Terraform Plan runs via reusable workflow
3. Workflow pauses at `prod` and `uat` environments
4. Go to **Actions** tab → Click on the workflow run
5. Click **Review deployments** button
6. **Select environments and approve** - Second approval checkpoint ✋
7. Terraform Apply runs and creates/updates resources

### **Reusable workflow pattern** (enterprise-grade)
- ✅ Azure authentication using service principal
- ✅ Runs for both prod and uat environments in parallel
- ✅ PR comments show terraform plan output
- ✅ **Environment-based approval gate** before apply
- ✅ Manual trigger with apply option
- ✅ Plan artifacts saved for review

## How Deployment Approval Works
**separate GitHub Environments** for each deployment:

1. **Environment Names:** `prod` and `uat`
2. **Trigger:** Automatic when merging to main or manual dispatch
3. **Approval Process:**
   - Workflow pauses before terraform apply for each environment
   - Configured reviewers get notified
   - Go to Actions tab → Click workflow run → "Review deployments"
   - Select which environments to approve (prod, uat, or both)
   - Click "Approve and deploy" button
   - Terraform apply proceeds for approved environments

**Benefits:**
- ✅ Separate approvers for production vs UAT
- ✅ Can approve UAT without approving production
- ✅ Different protection rules per environment
- ✅ Environment-specific deployment logs

**Configure reviewers:** Go to Settings → Environments → Select `prod` or `uat` → Add reviewers
**Update approvers:** Edit [terraform.yml](.github/workflows/terraform.yml) line with `approvers:` and add your GitHub username(s) separated by commas.

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
