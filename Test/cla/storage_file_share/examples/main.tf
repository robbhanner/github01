resource "random_string" "rg_suffix" {
  length  = 4
  special = false
  upper   = false
}

module "resource_group" {
  source  = "us.spacelift.io/claconnect/resource_group/azurerm"
  version = "1.0.0"

  resource_group_name = "${var.resource_group_name}-${random_string.rg_suffix.result}"
  location            = var.location
  tags                = var.tags
}

module "virtual_network" {
  source  = "us.spacelift.io/claconnect/virtual_network/azurerm"
  version = "1.0.0"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = module.resource_group.name
  location             = var.location

  vnet_address_space = [var.vnet_address_space]
  dns_servers        = []
  tags               = var.tags
}

module "subnet" {
  source  = "us.spacelift.io/claconnect/subnets/azurerm"
  version = "1.0.0"

  for_each = var.subnets

  resource_group_name                           = module.resource_group.name
  virtual_network_name                          = module.virtual_network.name
  subnet_name                                   = each.key
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
  service_endpoints                             = each.value.service_endpoints
  delegations                                   = each.value.delegations
}

module "private_dns_zone" {
  source  = "us.spacelift.io/claconnect/private_dns_zone/azurerm"
  version = "1.0.0"

  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = module.resource_group.name
  tags                  = var.tags
  virtual_network_ids   = var.virtual_network_ids

  depends_on = [ module.virtual_network ]
}


### NEED AN ACTIVE SL MODULE FOR DNS-ZONE-VNET-LINK
resource "azurerm_private_dns_zone_virtual_network_link" "vnetdnslink" {
  name                  = var.dnslinkname
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = module.virtual_network.id
}



#Commenting out PE SL module usage due to private_service_connection vars
#module "private_endpoint" {
#  source  = "us.spacelift.io/claconnect/private_endpoint/azurerm"
#  version = "1.0.0"
#
#  name = "${var.storage_account_name}-${random_id.private_endpoint_id.hex}-pe"
#  location = var.location
#  resource_group_name = module.resource_group.name
#  subnet_id = module.subnet[each.value.subnet_name].subnet_id
#  tags = var.tags
#  private_dns_zone_name = var.private_dns_zone_name
#  private_dns_zone_ids = var.private_dns_zone_ids
#  private_service_connection = var.private_service_connection
#}
#resource "random_id" "private_endpoint_id" {
#  byte_length = 2
#}


resource "azurerm_private_endpoint" "pep1" {
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet[each.value.subnet_name].subnet_id
  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = module.storage_file_share.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "dns-group1"
    private_dns_zone_ids = module.private_dns_zone.id
  }
  depends_on = [ module.storage_file_share ]
}



module "storage_file_share" {
  source = "../.."

  storage_account_name                   = var.storage_account_name
  location                               = var.location
  resource_group_name                    = module.resource_group.name
  account_kind                           = var.account_kind
  account_tier                           = var.account_tier
  storage_account_replication_type       = var.storage_account_replication_type
  min_tls_version                        = var.min_tls_version
  storage_account_is_gen2                = var.storage_account_is_gen2
  enable_https_traffic_only              = var.enable_https_traffic_only
  nfsv3_enabled                          = var.nfsv3_enabled
  allow_nested_items_to_be_public        = var.allow_nested_items_to_be_public
  tags                                   = var.tags
  identity_type                          = var.identity_type
  storage_account_network_default_action = var.storage_account_network_default_action
  storage_account_network_bypass         = var.storage_account_network_bypass
  storage_account_allowed_public_ips     = var.storage_account_allowed_public_ips
  share_name                             = var.share_name
  quota                                  = var.quota
}