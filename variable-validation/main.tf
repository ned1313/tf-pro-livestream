locals {
  allowed_regions      = ["eastus", "westus2", "centralus"]
  resource_group_name  = "${var.example_prefix}-rg"
  virtual_network_name = "${var.example_prefix}-vnet"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.default_tags
}

resource "azurerm_virtual_network" "main" {
  name                = local.virtual_network_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_cidr]
  tags                = var.default_tags
}

resource "azurerm_subnet" "main" {
  count = var.subnet_count

  name                 = format("%s-subnet-%02d", var.example_prefix, count.index + 1)
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, count.index)]
}