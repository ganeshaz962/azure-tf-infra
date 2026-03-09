# Management Groups and Platform Subscriptions

## 📋 Overview

This folder holds Azure CDX Management Groups and platform-related subscriptions, establishing the organizational hierarchy for governance, compliance, and billing across the entire CDX platform.

## 🏗️ Management Group Hierarchy

```
CDX (Root)
├── prod-platform
├── landing-zones
│   ├── mgmt
│   ├── corp
│   └── online
├── sandbox
├── decommissioned
└── cdx-test-environment
    ├── test-platform
    ├── test-landing-zone
    │   ├── mgmt
    │   ├── corp
    │   └── online
    └── test-sandbox
```

## 📁 Management Group Descriptions

### Production Environment

1. **prod-platform** - Contains platform-related subscriptions
   - Hub subscription
   - Web/API spoke subscriptions
   - Management subscription
   - Tools subscription

2. **landing-zones** - Team spoke subscriptions organized by connectivity type
   - **mgmt** - Team management spokes
   - **corp** - Team corp spokes (internal connectivity only)
   - **online** - Team online spokes (external connectivity only)

3. **sandbox** - Team and personal sandbox subscriptions for development and testing

4. **decommissioned** - Deleted/decommissioned subscriptions are moved here after deletion from pipeline

### Test Environment

5. **cdx-test-environment** - Mirror of production management groups for testing
   - **test-platform** - Platform testing resources
   - **test-landing-zone** - Team spoke testing
     - mgmt, corp, online (same structure as production)
   - **test-sandbox** - Sandbox testing environment

## 🔧 Platform Subscriptions

| Subscription | Purpose | Management Group |
|--------------|---------|------------------|
| **Management** | Platform monitoring, logging, and operational tools | prod-platform |
| **Tools** | Billing management for various Azure tools | prod-platform |
| **Hub (prod)** | Production hub network resources | prod-platform |
| **Hub (test)** | Test environment hub network resources | cdx-test-environment |

## 📜 Key Terraform Files

- **management-groups.tf** - Management group hierarchy definitions
- **subscriptions.tf** - Subscription assignments to management groups
- **role-definitions.tf** - Custom RBAC role definitions
- **backend.tf** - Remote state configuration
- **provider.tf** - Azure provider configuration
- **variables.tf** - Input variables

## 🚀 Deployment

Changes in this Terraform project are applied through a GitHub Actions workflow with the following characteristics:

- **Trigger**: Manual workflow dispatch
- **Approval Required**: Yes
- **State**: Stored in remote backend (Azure Storage Account)

### Deployment Process

1. Create a feature branch with management group changes
2. Submit pull request for review
3. After approval, merge to main branch
4. Automatically trigger GitHub workflow
5. Approve deployment in GitHub Actions
6. Monitor workflow execution

## ⚠️ Important Considerations

### Policy Inheritance

- Azure Policies assigned at management group level automatically apply to all child management groups and subscriptions
- Be careful when assigning policies at higher levels of the hierarchy

### Subscription Movement

- Moving subscriptions between management groups may temporarily affect resource access
- Plan subscription moves during maintenance windows
- Verify policy compliance after moving subscriptions

### Governance Best Practices

- Use consistent naming conventions across management groups
- Document the purpose of each management group
- Regularly review and audit management group structure
- Implement proper RBAC at the management group level

## 📖 Related Documentation

- [Azure Management Groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/)
- [Management Group Best Practices](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/management-group-and-subscription-organization)
- [Subscription Organization Patterns](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/decision-guides/subscriptions/)

## 🔙 Back to Main Documentation

[← Back to CDX Terraform Infrastructure](../README.md)
