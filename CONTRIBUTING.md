# Making Changes

## Simple Workflow

### 1. Create Branch
```bash
git checkout -b feature/your-change
```

### 2. Make Changes
Edit files in `hub/prod/` or `hub/uat/`

### 3. Push and Create PR
```bash
git add .
git commit -m "Your change description"
git push origin feature/your-change
```
Then create PR on GitHub

### 4. Review Terraform Plan
- Plan runs automatically on PR
- Review plan output in PR comments
- Approve PR and merge

### 5. Approve Deployment
- Go to Actions tab
- Click on the running workflow
- Click "Review deployments" (yellow banner)
- Select prod and/or uat
- Click "Approve and deploy"

Done! Infrastructure updates automatically.

## GitHub Setup (One-Time)

### Create Environments

**Settings** → **Environments** → **New environment**

1. Create `prod`
   - Required reviewers: Add yourself
   - Save

2. Create `uat`
   - Required reviewers: Add yourself
   - Save

### Branch Protection

**Settings** → **Branches** → **Add rule** for `main`
- ✅ Require pull request
- ✅ Require approvals: 1
- Save

That's it!

## Testing Locally (Optional)

```powershell
# Set Azure credentials
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"

# Test
cd hub/prod
terraform init
terraform plan
```
