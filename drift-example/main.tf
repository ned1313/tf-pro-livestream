locals {
  resource_group_name  = "${var.name_prefix}-rg"
  virtual_network_name = "${var.name_prefix}-vnet"

  default_tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location

  tags = local.default_tags
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.42.0.0/16"]

  tags = local.default_tags
}