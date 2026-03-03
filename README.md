# Azure Infrastructure Automation with Terraform

This repository manages Azure infrastructure as code using Terraform with fully automated CI/CD deployment via GitHub Actions.

## 📋 Overview

**What's Automated:**
- ✅ Azure Resource Group provisioning across multiple environments
- ✅ Pull Request workflow with Terraform plan preview
- ✅ Automated deployment after approval
- ✅ Environment-specific workflows (Production & UAT)
- ✅ Dual approval gates (PR review + deployment approval)
- ✅ Secure Azure authentication via GitHub Secrets

**Technology Stack:**
- Terraform 1.7.0
- Azure Provider ~> 3.0
- GitHub Actions (Reusable Workflow Pattern)
- Azure Service Principal Authentication

## 🏗️ Architecture

### Repository Structure

```
azure-tf-infra/
├── .github/
│   └── workflows/
│       ├── deploy.yml                 # Reusable workflow (plan/approve/apply)
│       ├── terraform-hub-prod.yml     # Production workflow caller
│       └── terraform-hub-uat.yml      # UAT workflow caller
├── hub/
│   ├── module/
│   │   └── resource-group/           # Reusable Terraform module
│   │       ├── main.tf               # Resource definitions
│   │       ├── variables.tf          # Input variables
│   │       └── outputs.tf            # Output values
│   ├── prod/                         # Production environment
│   │   └── main.tf                   # Prod configuration
│   └── uat/                          # UAT environment
│       └── main.tf                   # UAT configuration
└── README.md
```

### Workflow Design

```
┌─────────────────────────────────────────────────────────┐
│  Pull Request Created/Updated                           │
│  (Changes in hub/prod/** or hub/uat/**)                │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
         ┌───────────────┐
         │ Terraform Plan │  ← Runs automatically
         └───────┬───────┘
                 │
                 ▼
         ┌───────────────┐
         │ Comment on PR │  ← Shows plan output
         └───────────────┘
                 │
         ┌───────▼────────┐
         │   PR Review    │  ← Manual review
         └───────┬────────┘
                 │
         ┌───────▼────────┐
         │  Merge to Main │
         └───────┬────────┘
                 │
                 ▼
    ┌────────────────────────┐
    │  Workflow Triggers     │  ← Environment-specific
    │  (prod OR uat only)    │
    └────────┬───────────────┘
             │
             ▼
     ┌───────────────┐
     │ Terraform Plan │  ← Runs on main branch
     └───────┬───────┘
             │
             ▼
     ┌───────────────────┐
     │ Wait for Approval │  ← Environment gate
     └───────┬───────────┘
             │
             ▼
     ┌────────────────┐
     │ Terraform Apply │  ← Deploys infrastructure
     └────────────────┘
```

## 🚀 Setup Guide

### Step 1: Configure Azure Service Principal

Create a service principal with appropriate permissions:

```bash
az ad sp create-for-rbac --name "GitHub-Actions-Terraform" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}
```

Save the output values for the next step.

### Step 2: Add GitHub Secrets

Navigate to **Settings → Secrets and variables → Actions → New repository secret**

Add the following secrets:
- `AZURE_CLIENT_ID` - Application (client) ID
- `AZURE_CLIENT_SECRET` - Client secret value
- `AZURE_SUBSCRIPTION_ID` - Azure subscription ID
- `AZURE_TENANT_ID` - Directory (tenant) ID

### Step 3: Create GitHub Environments

Navigate to **Settings → Environments → New environment**

**Create `prod` environment:**
1. Enter name: `prod`
2. Click **Add environment**
3. Enable **Required reviewers**
4. Add reviewers (e.g., yourself or team members)
5. Click **Save protection rules**

**Create `uat` environment:**
1. Enter name: `uat`
2. Click **Add environment**
3. Enable **Required reviewers**
4. Add reviewers
5. Click **Save protection rules**

### Step 4: Enable Branch Protection (Optional but Recommended)

Navigate to **Settings → Branches → Add rule**

For `main` branch:
- ✅ Require a pull request before merging
- ✅ Require approvals (minimum: 1)
- ✅ Dismiss stale pull request approvals when new commits are pushed
- ✅ Require status checks to pass before merging

**✨ Setup Complete!** Your infrastructure automation is ready.

## 🔄 How It Works

### Workflow Components

#### 1. Reusable Workflow ([deploy.yml](.github/workflows/deploy.yml))

Central workflow containing all Terraform logic:
- **Plan Job**: Initializes, validates, and creates Terraform plan
- **Approve Job**: Waits for environment approval (requires GitHub Environment setup)
- **Apply Job**: Executes Terraform apply after approval

#### 2. Environment Workflows

**Production** ([terraform-hub-prod.yml](.github/workflows/terraform-hub-prod.yml))
- Triggers: Changes in `hub/prod/**`
- Calls: deploy.yml with `prod` environment

**UAT** ([terraform-hub-uat.yml](.github/workflows/terraform-hub-uat.yml))
- Triggers: Changes in `hub/uat/**`
- Calls: deploy.yml with `uat` environment

### Workflow Triggers

| Event | Behavior |
|-------|----------|
| **Pull Request** | Runs Terraform plan, posts results as PR comment. No approval needed. |
| **Push to Main** | Runs if files in environment path changed. Requires approval before apply. |
| **Manual Trigger** | Run from Actions tab. Option to apply immediately or plan only. |

### Smart Path Filtering

Workflows only trigger when relevant files change:

```yaml
prod workflow → triggers on: hub/prod/**
uat workflow  → triggers on: hub/uat/**
```

**Example:**
- Modify `hub/prod/main.tf` → Only **prod** workflow runs
- Modify `hub/uat/main.tf` → Only **uat** workflow runs
- Modify both → Both workflows run independently

## 📖 Usage Guide

### Making Infrastructure Changes

#### Standard Workflow

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/add-storage-account
   ```

2. **Make your changes:**
   ```bash
   # Edit hub/prod/main.tf or hub/uat/main.tf
   code hub/prod/main.tf
   ```

3. **Commit and push:**
   ```bash
   git add .
   git commit -m "Add storage account to production"
   git push origin feature/add-storage-account
   ```

4. **Create Pull Request:**
   - Go to GitHub → Pull Requests → New Pull Request
   - Terraform plan will run automatically
   - Review the plan output in PR comments

5. **Review and Merge:**
   - Review the Terraform plan
   - Request changes if needed
   - Approve and merge PR

6. **Monitor Deployment:**
   - Go to Actions tab
   - Workflow starts automatically after merge
   - Click on workflow run to see progress
   - **Approve deployment** when prompted
   - Monitor apply job completion

### Manual Workflow Run

1. Go to **Actions** tab
2. Select workflow (Terraform Hub - Prod or UAT)
3. Click **Run workflow**
4. Choose options:
   - `apply: false` → Plan only (no changes)
   - `apply: true` → Apply immediately (skip approval)
5. Click **Run workflow**

### Approval Process

**Dual Approval Gates:**

1. **PR Approval** (Code Review)
   - Reviews infrastructure code changes
   - Ensures code quality and correctness
   - Required before merge to main

2. **Deployment Approval** (Apply Gate)
   - Reviews Terraform plan before execution
   - Final safety check before infrastructure changes
   - Required before terraform apply runs

**Approving Deployments:**
1. Navigate to **Actions** tab
2. Click on running workflow
3. Expand **approve** job
4. Click **Review pending deployments**
5. Select environment (`prod` or `uat`)
6. Click **Approve and deploy**

## 💻 Local Development

### Prerequisites

- Terraform >= 1.7.0
- Azure CLI
- Git

### Local Testing

**1. Authenticate with Azure:**

```powershell
# PowerShell
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"
```

```bash
# Bash/Linux
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

**2. Navigate to environment:**

```bash
cd hub/prod  # or hub/uat
```

**3. Initialize Terraform:**

```bash
terraform init
```

**4. Format code:**

```bash
terraform fmt
```

**5. Validate configuration:**

```bash
terraform validate
```

**6. Plan changes:**

```bash
terraform plan
```

**7. Apply changes (if needed):**

```bash
terraform apply
```

### Module Development

The repository uses a modular structure. To add new modules:

1. Create new module under `hub/module/`
2. Define resources in `main.tf`
3. Document variables in `variables.tf`
4. Define outputs in `outputs.tf`
5. Reference module in environment configs (`hub/prod/main.tf`, `hub/uat/main.tf`)

## 🌍 Environments

### Production Environment (`hub/prod`)

| Property | Value |
|----------|-------|
| **Environment** | Production |
| **Resource Group** | `rg-hub-prod` |
| **Location** | East US |
| **GitHub Environment** | `prod` |
| **Workflow** | [terraform-hub-prod.yml](.github/workflows/terraform-hub-prod.yml) |

### UAT Environment (`hub/uat`)

| Property | Value |
|----------|-------|
| **Environment** | UAT (User Acceptance Testing) |
| **Resource Group** | `rg-hub-uat` |
| **Location** | East US |
| **GitHub Environment** | `uat` |
| **Workflow** | [terraform-hub-uat.yml](.github/workflows/terraform-hub-uat.yml) |

## 🔧 Troubleshooting

### Common Issues

#### ❌ Workflow Not Triggering After PR Merge

**Symptoms:** PR merged but workflow doesn't run

**Solutions:**
1. Verify file changes are in correct path (`hub/prod/**` or `hub/uat/**`)
2. Check workflow file paths filter in workflow YAML
3. Confirm push event is enabled for main branch
4. Review Actions tab for any error messages

#### ❌ Approval Gate Not Working

**Symptoms:** Workflow applies immediately without approval

**Solutions:**
1. Verify GitHub Environments exist (`prod` and `uat`)
2. Confirm required reviewers are configured in environment settings
3. Check environment name matches workflow configuration
4. Ensure you're not triggering with `apply: true` in workflow_dispatch

#### ❌ Terraform Authentication Failure

**Symptoms:** `Error: building AzureRM Client: authenticate failed`

**Solutions:**
1. Verify all four Azure secrets are configured correctly
2. Check service principal has Contributor role on subscription
3. Confirm secrets names match exactly: `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`
4. Test service principal credentials locally

#### ❌ Both Workflows Triggering

**Symptoms:** Changing prod triggers uat workflow (or vice versa)

**Solutions:**
1. Verify path filters don't include `hub/module/**`
2. Ensure changes are only in one environment directory
3. Check git diff to confirm which files were modified

#### ❌ Terraform Plan Fails

**Symptoms:** Plan job fails with validation errors

**Solutions:**
1. Run `terraform fmt` locally before committing
2. Run `terraform validate` locally to catch errors
3. Check syntax errors in .tf files
4. Verify module references are correct

### Getting Help

1. Check workflow run logs in Actions tab
2. Review Terraform error messages
3. Verify Azure permissions and quotas
4. Check GitHub Actions documentation

## 🔐 Security Best Practices

- ✅ Never commit Azure credentials to repository
- ✅ Use GitHub Secrets for sensitive values
- ✅ Rotate service principal credentials regularly
- ✅ Use least privilege principle for service principal permissions
- ✅ Enable branch protection on main branch
- ✅ Require pull request reviews before merging
- ✅ Enable required reviewers for production deployments
- ✅ Regularly audit GitHub Actions logs
- ✅ Keep Terraform and provider versions up to date

## 📝 Git Commands Reference

### Branch Management

```bash
# Create new branch
git checkout -b feature/your-feature-name

# List branches
git branch -a

# Delete local branch
git branch -d branch-name
git branch -D branch-name  # Force delete

# Delete remote branch
git push origin --delete branch-name

# Switch branches
git checkout branch-name
```

### Commit Workflow

```bash
# Check status
git status

# Stage changes
git add .
git add specific-file.tf

# Commit changes
git commit -m "Descriptive commit message"

# Push changes
git push origin branch-name

# Pull latest changes
git pull origin main
```

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Service Principal Setup](https://docs.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure)

## 📄 License

This project is maintained for internal infrastructure management.

## 👥 Contributing

1. Create a feature branch from `main`
2. Make your changes following Terraform best practices
3. Run `terraform fmt` and `terraform validate` locally
4. Commit with clear, descriptive messages
5. Push and create a Pull Request
6. Review Terraform plan output in PR comments
7. Request review from team members
8. Merge after approval
9. Monitor deployment in Actions tab
10. Approve infrastructure deployment when prompted

---

**⚡ Quick Links:**
- [Production Workflow](.github/workflows/terraform-hub-prod.yml)
- [UAT Workflow](.github/workflows/terraform-hub-uat.yml)
- [Reusable Workflow](.github/workflows/deploy.yml)
- [Actions Tab](../../actions)