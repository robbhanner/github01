## Shared Properties ##

variable "location" {
  description = "The Azure Region in which to place the newly created Storage Account"
  type        = string
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "Azure Tags that should be added to the newly created Storage Account"
  default     = {}
  nullable    = false
}

## Module Properties ##

variable "resource_group_name" {
  description = "The Storage Account Resource Group Name that will host the newly created Storage Account"
  type        = string
  nullable    = false
}

variable "storage_account_name" {
  type        = string
  description = "The object name of the the newly created Storage Account"
  nullable    = false
}

variable "account_kind" {
  type        = string
  description = "Defines the type of the the newly created Storage Account"
  default     = "StorageV2"
  nullable    = false

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Storage Account needs to match supported Tier (BlobStorage/BlockBlobStorage/FileStorage/Storage/StorageV2)."
  }
}

variable "account_tier" {
  type        = string
  description = "Defines the tier for the stroage account."
  default     = "Standard"
  nullable    = false

  validation {
    condition     = contains(["Standard", "premium"], var.account_tier)
    error_message = "Storage Account needs to match supported Tier (Standard/Premium)."
  }
}
variable "storage_account_replication_type" {
  type        = string
  description = "The Storage Account Replication Type."
  nullable    = false

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The sku must be one of: LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account."
  default     = "TLS1_2"
  nullable    = false
}

variable "enable_https_traffic_only" {
  type        = bool
  description = " Forces HTTPS if enabled."
  default     = true
  nullable    = false
}

variable "nfsv3_enabled" {
  type        = bool
  description = "Enable nfsv3 protocol."
  default     = false
  nullable    = false
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  nullable    = false
  description = " Allow or disallow nested items within this Account to opt into being public."
  default     = false
}


variable "storage_account_access_tier" {
  type        = string
  description = "The Storage Account Access Tier"
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool"], var.storage_account_access_tier)
    error_message = "The sku must be one of Hot or Cool."
  }
}



variable "storage_account_is_gen2" {
  type        = bool
  description = "Is Hierarchical Namespace or Gen2 SKU in the Storage Account.  Note this generally not have as deep of backup/soft delete options."
  default     = false
  nullable    = false
}



## Network Rules Properties

variable "storage_account_network_default_action" {
  validation {
    condition     = contains(["Allow", "Deny"], var.storage_account_network_default_action)
    error_message = "Must contain 'Allow' or 'Deny'"
  }
  type        = string
  description = "Specifies if default action is to allow or deny traffic to storage account"
  nullable    = false
}

variable "storage_account_allowed_public_ips" {
  type        = list(string)
  description = "Allowed Map of Public IP Addresses to this Storage Account"
  default     = []
  nullable    = false
  # validation {
  #   condition     = can([for ip in var.storage_account_allowed_public_ips : cidrhost(split(ip, "/")[0],split(ip, "/")[1])])
  #   error_message = "These must all be valid ipv4 Public IP Addresses."
  # }
}

variable "storage_account_network_bypass" {
  type        = list(string)
  description = "Allowed Values for bypassing the Firewall"
  default     = ["AzureServices"]
  nullable    = false
  validation {
    condition     = contains(var.storage_account_network_bypass, "AzureServices") || contains(var.storage_account_network_bypass, "Logging") || contains(var.storage_account_network_bypass, "Metrics") || contains(var.storage_account_network_bypass, "None")
    error_message = "These must any combination of: AzureServices, Logging, Metrics, or None."
  }
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "Specifies the list of ID's, containing Resource ID Strings of the subnets to allow access for the newly created Storage Account"
  default     = null
  nullable    = true
}

## Identity Properties

variable "identity_type" {
  type        = string
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account."
  default     = "SystemAssigned"
  nullable    = false

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Must contain 'SystemAssigned', 'SystemAssigned' or 'SystemAssigned, UserAssigned' for Identity Type"
  }
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
  default     = null
  nullable    = true
}


### File Share Properties

variable "share_name" {
  type        = string
  description = "Specifies the name of the file share to be created"
  nullable    = false
}

variable "quota" {
  type        = number
  description = "Specifies the maximum size of the share, in gigabytes"
}

variable "share_access_tier" {
  type        = string
  description = "The access tier of the File Share.  Possible values are Hot, Cool, TransactionOptimized, and Premium"
  default     = "Hot"
  nullable    = false
}

variable "share_protocol" {
  type        = string
  description = "The protocol used for the share. Possible values are SMB and NFS"
  default     = "SMB"
  nullable    = false
}

variable "share_acl_id" {
  type        = string
  description = "The ID which should be used for this Shared Identifier"
  nullable    = false
}

variable "share_ap_perms" {
  type        = string
  description = "The permissions which should be associated with this Shared Identifier. Possible value is combination of r w d and l"
  default     = "rwdl"
  nullable    = false
}

variable "share_ap_start" {
  type        = string
  description = "The time at which this Access Policy should be valid from, in RFC3339/ISO8601 format - 2025-04-08T09:18:21Z "
  nullable    = true
}

variable "share_ap_end" {
  type        = string
  description = "The time at which this Access Policy should be valid until, in RFC3339/ISO8601 format"
  nullable    = true
}