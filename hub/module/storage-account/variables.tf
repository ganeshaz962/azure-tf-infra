variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, 3-24 chars, lowercase letters and numbers only)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the storage account"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Storage account kind (BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2)"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "Access tier for BlobStorage and StorageV2 accounts (Hot or Cool)"
  type        = string
  default     = "Hot"
}

variable "min_tls_version" {
  description = "Minimum TLS version (TLS1_0, TLS1_1, TLS1_2)"
  type        = string
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS traffic only"
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow blob public access"
  type        = bool
  default     = false
}

variable "containers" {
  description = "List of blob containers to create"
  type = list(object({
    name        = string
    access_type = optional(string, "private")
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
