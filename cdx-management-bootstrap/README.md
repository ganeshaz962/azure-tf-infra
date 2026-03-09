# CDX Management Bootstrap

## 📋 Overview

This folder contains Terraform code for the initial **manual** bootstrap of CDX platform resources. These are foundational resources that must be created before any other infrastructure can be deployed.

## 🏗️ Components

### 1. tfstate_storage_account

Creates the foundational storage infrastructure for Terraform state management.

**Resources Created:**
- Resource Group in cdx-management subscription
- Storage Account for Terraform remote state
- Storage Container for state files

**Purpose:** Provides centralized Terraform state storage for all CDX infrastructure projects.

### 2. prod

Creates essential security and automation resources for the CDX platform.

**Resources Created:**
- Service Principals for platform automation
- Azure Key Vault for secrets management
- Initial RBAC configurations

**Purpose:** Establishes core authentication and secrets management infrastructure.

## ⚠️ Important Notes

### Manual Execution Required

This code **cannot be run from CI/CD pipelines** and must be executed manually on a local machine. This is by design to ensure proper bootstrap control and security.

### Prerequisites

To execute this bootstrap code, you need:

1. **Azure CLI** installed and authenticated
2. **Terraform** version >= 1.12
3. **Contributor access** to the cdx-management subscription

## 🚀 Deployment Order

1. **First:** Deploy `tfstate_storage_account` to create state storage
2. **Second:** Deploy `prod` to create service principals and Key Vault

## 🔙 Back to Main Documentation

[← Back to CDX Terraform Infrastructure](../README.md)
