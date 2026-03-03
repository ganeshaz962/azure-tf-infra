# Contributing to Azure Infrastructure

## Workflow

### Overview
This project uses a **two-stage approval process** to ensure all infrastructure changes are reviewed before deployment:
1. **PR Review** - Review terraform plan in pull request
2. **Deployment Approval** - Approve before terraform apply

### 1. Create a Feature Branch
```bash
git checkout -b feature/add-storage-account
```

### 2. Make Your Changes
Edit Terraform files as needed in `hub/prod/` or `hub/uat/`

### 3. Test Locally (Optional)
```bash
cd hub/prod
terraform init
terraform plan
```

### 4. Commit and Push
```bash
git add .
git commit -m "Add storage account to production"
git push origin feature/add-storage-account
```

### 5. Create Pull Request
- Go to GitHub repository
- Click **Pull requests** → **New pull request**
- Select your feature branch
- Click **Create pull request**

### 6. Review Terraform Plan (First Approval)
- ✅ Terraform Plan runs automatically
- ✅ Plan output appears as PR comment
- ✅ Review the changes carefully
- ✅ Request review from teammates if needed
- ✅ **Approve and merge the PR** (First approval gate)

### 7. Deployment Approval (Second Approval)
After merge:
- Workflow runs on main branch
- Terraform Plan executes
- Workflow pauses at "Approval Required" job
- Go to **Actions** tab → Select the workflow run
- Click **Review deployments** button
- **Approve** to proceed (Second approval gate)
- Terraform Apply runs and creates resources

## Branch Protection (Recommended)

Configure in **Settings → Branches → Branch protection rules** for `main`:

1. ✅ Require a pull request before merging
2. ✅ Require approvals (minimum 1)
3. ✅ Require status checks to pass
4. ✅ Require branches to be up to date

## Environment Setup

Configure in **Settings → Environments**:

1. Create environment named: `production`
2. Enable **Required reviewers**
3. Add reviewers (yourself and/or team members)
4. Save protection rules

## Best Practices

- **Never commit directly to main**
- Always create a feature branch
- Write descriptive commit messages
- Review terraform plan output before merging
- Keep changes small and focused
- Update documentation when needed
- Test locally before pushing

## Testing Locally

### Set Azure Credentials
```powershell
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"
```

### Run Terraform Commands
```bash
terraform init
terraform fmt        # Format code
terraform validate   # Validate syntax
terraform plan       # Preview changes
```

## Getting Help

If you have questions or need help:
1. Check existing documentation
2. Review closed PRs for examples
3. Contact the infrastructure team
