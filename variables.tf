variable "name" {
  type        = string
  description = "Name for this PostgreSQL Flexible Server"
  nullable    = false
}

variable "resource_group_name" {
  description = "Name for this Resource Group"
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure Region to create the resource in"
  type        = string
  nullable    = false
}

variable "version_num" {
  type        = number
  description = "The version of PostgreSQL FS to use. Possible vaules are 11, 12, 13, 14, 15, 16.  Required when create_mode is 'Default'"
  default     = null
}

variable "delegated_subnet_id" {
  type        = string
  description = "The ID of the virtual network subnet to create the PostgreSQL Flexible Server"
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone to create the PostgreSQL Flexible Server"
}

variable "administrator_login" {
  type = string
}

variable "administrator_password" {
  type = string
}

variable "zone" {
  type        = string
  description = "Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located"
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Additional default tags to add to the resources being deployed at this layer."
  default     = {}
}

variable "storage_mb" {
  type        = number
  description = "Max storage allowed for the PostgreSQL FS. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408"
  default     = "32768"
}

variable "storage_tier" {
  type        = string
  description = "Storage performance tier for IOPS of the PostgreSQL FS. Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80. Default value is dependant on the storage_mb value"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3, etc.)"
  default     = "B_Standard_B1ms"
}

variable "create_mode" {
  type        = string
  description = "The creation mode which can be used to restore or replicate existing servers. Possible values are Default, GeoRestore, PointInTimeRestore, Replica and Update"
  default     = "Default"
}

variable "backup_retention_days" {
  type        = number
  description = "Possible values are between 7 and 35 days"
  default     = "7"
}

variable "geo_redundant_backup_enabled" {
  type        = string
  description = "Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server"
  default     = "false"
}

variable "auto_grow_enabled" {
  type        = string
  description = "Is the storage auto grow for PostgreSQL Flexible Server enabled?"
  default     = "false"
}



variable "vnet1name" {
  type = string
}
variable "vnet1cidr" {
  type = string
}
variable "subnet1name" {
  type = string
}
variable "snet1name" {
  type = string
}
variable "snet1cidr" {
  type = string
}
variable "subnet1cidr" {
  type = string
}
variable "environment" {
  type = string
  default = "Test"
}

variable "storagename" {
  type = string
}

variable "sharename" {
  type = string
}