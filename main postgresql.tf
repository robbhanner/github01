terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = [var.vnet1cidr]
}

#Trying PE Subnet for PostgreSQL Flexible Servers
resource "azurerm_subnet" "snet1" {
  name                 = var.snet1name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.snet1cidr]
  service_endpoints    = ["Microsoft.Storage"]
  #delegation {
  #  name = "fs"
  #  service_delegation {
  #    name = "Microsoft.DBforPostgreSQL/flexibleServers"
  #    actions = [
  #      "Microsoft.Network/virtualNetworks/subnets/join/action",
  #    ]
  #  }
  # }
}

resource "azurerm_private_dns_zone" "privdns1" {
  name                = "psqlfs1-pdz.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetdnslink1" {
  name                  = "vnet1dnslink"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.privdns1.name
  virtual_network_id    = azurerm_virtual_network.vnet1.id
}


resource "azurerm_postgresql_flexible_server" "postgresql_fs" {
  #Required Arguments
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  #Optional Arguments
  version = var.version_num
  #delegated_subnet_id    = azurerm_subnet.snet1.id
  private_dns_zone_id    = azurerm_private_dns_zone.privdns1.id
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = var.zone
  tags                   = var.tags

  public_network_access_enabled = false

  storage_mb = var.storage_mb
  #storage_tier = var.storage_tier

  sku_name    = var.sku_name
  create_mode = var.create_mode

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  #auto_grow_enabled            = var.auto_grow_enabled
}

resource "azurerm_private_endpoint" "pep1" {
  name                = "pep1"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.snet1.id
  depends_on          = [azurerm_postgresql_flexible_server.postgresql_fs]

  private_service_connection {
    name                           = "postgresql-test-psc1"
    private_connection_resource_id = azurerm_postgresql_flexible_server.postgresql_fs.id
    #https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names    = ["postgresqlServer"]
    is_manual_connection = false
  }
}
#resource "azurerm_postgresql_flexible_server" "pgsql" {
#  name                = "hanner-psqlfs1"
#  resource_group_name = azurerm_resource_group.rg1.name
#  location            = azurerm_resource_group.rgterr1.location
#  version             = "12"
#  delegated_subnet_id = azurerm_subnet.snet1.id
#  private_dns_zone_id = azurerm_private_dns_zone.privdns1.id
#  #public_network_access_enabled = false  #Not needed when delegated subnet id and private dns zone id are set
#  administrator_login    = "psqladmin"
#  administrator_password = "H@Sh1CoR3!"
#  zone                   = "1"
#
#  storage_mb = 32768
#  # storage_tier = "P4"
#
#  sku_name   = "B_Standard_B1ms"
#  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnetdnslink1]
#}
