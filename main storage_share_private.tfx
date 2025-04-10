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

resource "azurerm_storage_account" "storage1" {
  name                              = var.storagename
  resource_group_name               = azurerm_resource_group.rg1.name
  location                          = azurerm_resource_group.rg1.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true

  network_rules {
    default_action = "Deny"
    ip_rules       = ["70.185.192.48"]
    #virtual_network_subnet_ids = [azurerm_subnet.snet1.id]
  }
}


resource "azurerm_storage_share" "share1" {
  name                 = var.sharename
  storage_account_name = azurerm_storage_account.storage1.name
  quota                = 50
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

resource "azurerm_private_endpoint" "pep1" {
  name                = "storagepep1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.snet1.id

  private_service_connection {
    name                           = "storage-psc1"
    private_connection_resource_id = azurerm_storage_account.storage1.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group1"
    private_dns_zone_ids = [azurerm_private_dns_zone.privdns1.id]
  }
}



