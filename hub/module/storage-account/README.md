# Storage Account Module

This module creates an Azure Storage Account with blob containers.

## Features

- Creates Azure Storage Account with configurable settings
- Supports multiple blob containers
- Security defaults (HTTPS only, TLS 1.2, private access)
- Flexible replication and tier options
- Comprehensive tagging support

## Usage

```hcl
module "storage_account" {
  source = "../module/storage-account"

  storage_account_name     = "sthubprod001"
  resource_group_name      = "rg-hub-prod"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  containers = [
    {
      name        = "data"
      access_type = "private"
    },
    {
      name        = "logs"
      access_type = "private"
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| storage_account_name | Name of the storage account (3-24 chars, lowercase, alphanumeric) | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region for the storage account | `string` | n/a | yes |
| account_tier | Storage account tier (Standard or Premium) | `string` | `"Standard"` | no |
| account_replication_type | Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS) | `string` | `"LRS"` | no |
| account_kind | Storage account kind | `string` | `"StorageV2"` | no |
| access_tier | Access tier (Hot or Cool) | `string` | `"Hot"` | no |
| min_tls_version | Minimum TLS version | `string` | `"TLS1_2"` | no |
| enable_https_traffic_only | Force HTTPS traffic only | `bool` | `true` | no |
| allow_nested_items_to_be_public | Allow blob public access | `bool` | `false` | no |
| containers | List of blob containers to create | `list(object)` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

### Container Object Structure

```hcl
{
  name        = string  # Container name
  access_type = string  # Optional: private, blob, or container (default: private)
}
```

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| storage_account_id | ID of the storage account | No |
| storage_account_name | Name of the storage account | No |
| primary_blob_endpoint | Primary blob endpoint | No |
| primary_access_key | Primary access key | Yes |
| secondary_access_key | Secondary access key | Yes |
| primary_connection_string | Primary connection string | Yes |
| container_names | List of container names | No |

## Naming Conventions

Storage account names must:
- Be between 3-24 characters
- Contain only lowercase letters and numbers
- Be globally unique across Azure

## Replication Types

- **LRS** (Locally-redundant storage) - 3 copies in single datacenter
- **ZRS** (Zone-redundant storage) - 3 copies across availability zones
- **GRS** (Geo-redundant storage) - 6 copies across 2 regions
- **RAGRS** (Read-access geo-redundant) - GRS with read access to secondary
- **GZRS** (Geo-zone-redundant) - ZRS + GRS
- **RAGZRS** (Read-access geo-zone-redundant) - GZRS with read access

## Security Features

- **HTTPS only** - Enforced by default
- **TLS 1.2** - Minimum version enforced
- **Private containers** - Default access type
- **No public blob access** - Disabled by default

## Access Tiers

- **Hot** - Optimized for frequent access, higher storage cost, lower access cost
- **Cool** - Optimized for infrequent access (30+ days), lower storage cost, higher access cost

## Examples

### Basic Storage Account

```hcl
module "storage" {
  source = "../module/storage-account"

  storage_account_name     = "stbasic001"
  resource_group_name      = "rg-prod"
  location                 = "Central India"

  tags = {
    Environment = "Production"
  }
}
```

### Premium Storage Account

```hcl
module "premium_storage" {
  source = "../module/storage-account"

  storage_account_name     = "stpremium001"
  resource_group_name      = "rg-prod"
  location                 = "Central India"
  account_tier             = "Premium"
  account_kind             = "BlockBlobStorage"
  account_replication_type = "ZRS"

  tags = {
    Environment = "Production"
  }
}
```

### Storage with Multiple Containers

```hcl
module "app_storage" {
  source = "../module/storage-account"

  storage_account_name     = "stapp001"
  resource_group_name      = "rg-prod"
  location                 = "Central India"

  containers = [
    { name = "uploads", access_type = "private" },
    { name = "images", access_type = "private" },
    { name = "documents", access_type = "private" },
    { name = "archive", access_type = "private" }
  ]

  tags = {
    Environment = "Production"
  }
}
```
