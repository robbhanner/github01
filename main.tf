terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  #  subscription_id = "c5d35f87-827d-4224-85d9-a5fac1b90b9b"
  #  client_id       = "c99d3296-4fdd-4dd0-ad7e-6ac44293bf95"
  #  client_secret   = "mzi8Q~R_Rx2Np6S.BBI5vOyi3CZMIT5MNL770b2Z"
  #  tenant_id       = "9c8d7196-e4cf-4c75-9312-3b2fc26f41e6"
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
  tags = {
    environment = var.environment
  }
}
