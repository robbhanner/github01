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
  name     = var.rgname
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = [var.vnet1cidr]
}

resource "azurerm_subnet" "snet1" {
  name                 = var.subnet1name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.snet1cidr]
}

resource "azurerm_private_dns_zone" "privdns1" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetdnslink1" {
  name                  = "vnet1dnslink"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.privdns1.name
  virtual_network_id    = azurerm_virtual_network.vnet1.id
}

resource "azurerm_postgresql_flexible_server" "pgsql" {
  name                          = "example-psqlflexibleserver"
  resource_group_name           = azurerm_resource_group.rg1.name
  location                      = azurerm_resource_group.rg1.location
  version                       = "12"
  delegated_subnet_id           = azurerm_subnet.snet1.id
  private_dns_zone_id           = azurerm_private_dns_zone.privdns1.id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = "H@Sh1CoR3!"
  zone                          = "1"

  storage_mb   = 32768
  # storage_tier = "P4"

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnetdnslink1]
}
