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
- Main workflow ([deploy.yml](.github/workflows/deploy.yml)) triggers
- Calls reusable workflow for each environment
- Terraform Plan executes for both prod and uat
- Workflow pauses at `prod` and `uat` environments
- Go to **Actions** tab → Select the workflow run
- Click **Review deployments** button (yellow banner at top)
- Select environments to approve (prod, uat, or both)
- Click **Approve and deploy** (Second approval gate)
- Terraform Apply runs for approved environments

**Note:** You can approve UAT and prod separately if needed.

## Branch Protection (Recommended)

Configure in **Settings → Branches → Branch protection rules** for `main`:

1. ✅ Require a pull request before merging
2. ✅ Require approvals (minimum 1)
3. ✅ Require status checks to pass
4. ✅ Require branches to be up to date

## Environment Configuration

### Setup Approval Environments

**Create Production Environment:**
1. Go to **Settings** → **Environments**
2. Click **New environment**
3. Name: **`prod`** (must match workflow)
4. Under **Deployment protection rules**:
   - ✅ Check **Required reviewers**
   - Add production approvers (senior team members)
   - Optionally set wait timer (e.g., 5 minutes)
5. Click **Save protection rules**

**Create UAT Environment:**
1. Click **New environment** again
2. Name: **`uat`**
3. Under **Deployment protection rules**:
   - ✅ Check **Required reviewers**
   - Add UAT approvers (can be less restrictive)
4. Click **Save protection rules**

### Benefits of Separate Environments

- **Different approvers:** Production can require senior approval
- **Independent approvals:** Deploy to UAT without affecting prod
- **Different rules:** Stricter wait times for production
- **Clear audit trail:** See who approved what environment

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
