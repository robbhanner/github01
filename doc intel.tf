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

resource "azurerm_cognitive_account" "docintel1" {
  name                = "docintel-test"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  kind                       = "FormRecognizer"
  #dynamic_throttling_enabled = false
  local_auth_enabled         = true

  custom_subdomain_name              = "infradocinteltest123ABC"
  outbound_network_access_restricted = false
  public_network_access_enabled      = false

  sku_name = "S0"

  tags = {
  }

  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }

  identity {
    type = "SystemAssigned"
    identity_ids = []
  }
}

resource "azurerm_private_dns_zone" "privdns1" {
  #https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.rg1.name
}



resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
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



resource "azurerm_private_dns_zone_virtual_network_link" "vnetdnslink1" {
  name                  = "vnet1dnslink"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.privdns1.name
  virtual_network_id    = azurerm_virtual_network.vnet1.id
}

resource "azurerm_private_endpoint" "pep1" {
  name                = "pep1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.snet1.id

  private_service_connection {
    name                           = "storage-psc1"
    private_connection_resource_id = azurerm_cognitive_account.docintel1.id
    #https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names    = ["account"]
    is_manual_connection = false
  }

  private_dns_zone_group {
    name                 = "dns-group1"
    private_dns_zone_ids = [azurerm_private_dns_zone.privdns1.id]
  }
}



