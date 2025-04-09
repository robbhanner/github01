<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.storage_container_public_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the type of the the newly created Storage Account | `string` | `"StorageV2"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defines the tier for the stroage account. | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. | `bool` | `false` | no |
| <a name="input_change_feed_enabled"></a> [change\_feed\_enabled](#input\_change\_feed\_enabled) | Is the blob service properties for change feed events enabled | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Forces HTTPS if enabled. | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Storage Account. | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region in which to place the newly created Storage Account | `string` | n/a | yes |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | Enable nfsv3 protocol. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Storage Account Resource Group Name that will host the newly created Storage Account | `string` | n/a | yes |
| <a name="input_soft_delete_blobs_days"></a> [soft\_delete\_blobs\_days](#input\_soft\_delete\_blobs\_days) | The number of days to allow recovery of blobs that were marked for deletion in the newly created Storage Account | `number` | `7` | no |
| <a name="input_soft_delete_containers_days"></a> [soft\_delete\_containers\_days](#input\_soft\_delete\_containers\_days) | The number of days to allow recovery of containers that were marked for deletion in the newly created Storage Account | `number` | `7` | no |
| <a name="input_storage_account_access_tier"></a> [storage\_account\_access\_tier](#input\_storage\_account\_access\_tier) | The Storage Account Access Tier | `string` | `"Hot"` | no |
| <a name="input_storage_account_allowed_public_ips"></a> [storage\_account\_allowed\_public\_ips](#input\_storage\_account\_allowed\_public\_ips) | Allowed Map of Public IP Addresses to this Storage Account | `list(string)` | `[]` | no |
| <a name="input_storage_account_containers"></a> [storage\_account\_containers](#input\_storage\_account\_containers) | Set of private Container names to create within the newly created Storage Account | `set(string)` | `[]` | no |
| <a name="input_storage_account_containers_public_blob"></a> [storage\_account\_containers\_public\_blob](#input\_storage\_account\_containers\_public\_blob) | Set of container names to create with an access level of 'blob' within the newly created Storage Account | `set(string)` | `[]` | no |
| <a name="input_storage_account_is_gen2"></a> [storage\_account\_is\_gen2](#input\_storage\_account\_is\_gen2) | Is Hierarchical Namespace or Gen2 SKU in the Storage Account.  Note this generally not have as deep of backup/soft delete options. | `bool` | `false` | no |
| <a name="input_storage_account_is_versioning_enabled"></a> [storage\_account\_is\_versioning\_enabled](#input\_storage\_account\_is\_versioning\_enabled) | Are blobs versioned in the Storage Account?  Defaults to True | `bool` | `false` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The object name of the the newly created Storage Account | `string` | n/a | yes |
| <a name="input_storage_account_network_bypass"></a> [storage\_account\_network\_bypass](#input\_storage\_account\_network\_bypass) | Allowed Values for bypassing the Firewall | `list(string)` | <pre>[<br/>  "AzureServices"<br/>]</pre> | no |
| <a name="input_storage_account_network_default_action"></a> [storage\_account\_network\_default\_action](#input\_storage\_account\_network\_default\_action) | Specifies if default action is to allow or deny traffic to storage account | `string` | n/a | yes |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The Storage Account Replication Type. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Azure Tags that should be added to the newly created Storage Account | `map(string)` | `{}` | no |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | Specifies the list of ID's, containing Resource ID Strings of the subnets to allow access for the newly created Storage Account | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->