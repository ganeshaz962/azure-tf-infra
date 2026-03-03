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

### 2. Setup Approval Environment
Go to **Settings** → **Environments** → **New environment**

Create: `production`
- Enable **Required reviewers**
- Add yourself as reviewer
- Save

### 3. Enable Branch Protection
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
# Create PR on GitHub, review plan, approve & merge 
# Then approve deployment in Actions tab
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
│  ├─ Workflow pauses                                         │
│  └─ [APPROVAL 2] Approve deployment in Actions tab ✋       │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Terraform Apply                                            │
│  ├─ Authenticates to Azure                                  │
│  ├─ Creates/updates resources                               │
│  └─ ✓ Infrastructure deployed                               │
└─────────────────────────────────────────────────────────────┘
```

### Simple 2-Stage Approval Process

**Stage 1: Pull Request Review (First Approval)**
1. Create a PR with your infrastructure changes
2. Terraform Plan runs automatically
3. Plan output is posted as a comment on the PR
4. **Review and approve the PR** - First approval checkpoint ✋
5. Merge to main branch

**Stage 2: Deployment Approval (Second Approval)**
1. After PR is merged to main
2. Terraform Plan runs again on main branch
3. Workflow pauses and waits for deployment approval
4. **Approve the workflow run** in GitHub Actions - Second approval checkpoint ✋
5. Terraform Apply runs and creates/updates resources

### Workflow Features
- ✅ Azure authentication using service principal secrets
- ✅ Runs for both prod and uat environments
- ✅ PR comments show terraform plan output
- ✅ Two approval gates: PR review + deployment approval
- ✅ Manual trigger available via workflow_dispatch

## Setup Deployment Approval

**Configure the `production` environment in GitHub:**

1. Go to **Settings** → **Environments**
2. Click **New environment** → name it `production`
3. Under **Deployment protection rules**:
   - ✅ Enable **Required reviewers**
   - Add yourself or team members as reviewers
4. Click **Save protection rules**

Now the workflow will wait for your approval before running terraform apply!

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
