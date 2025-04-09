resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage_account_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.storage_account_replication_type
  min_tls_version                 = var.min_tls_version
  is_hns_enabled                  = var.storage_account_is_gen2
  https_traffic_only_enabled      = var.enable_https_traffic_only
  nfsv3_enabled                   = var.nfsv3_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  tags                            = var.tags

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  network_rules {
    default_action             = var.storage_account_network_default_action
    bypass                     = var.storage_account_network_bypass
    ip_rules                   = var.storage_account_allowed_public_ips
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      network_rules
    ]
  }
}

resource "azurerm_storage_share" "share" {
  name                 = var.share_name
  storage_account_name = var.storage_account_name
  quota                = var.quota
  access_tier          = var.share_access_tier
  enabled_protocol     = var.share_protocol


  # Share ACL Block (Optional) - Commented out because "id" and "permissions" are required values within the optional block
  #  acl {
  #    id = var.share_acl_id
  #
  #    access_policy {
  #      permissions = var.share_ap_perms
  #      start = var.share_ap_start
  #      expiry  = var.share_ap_end
  #    }
  #  }

}
