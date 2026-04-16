resource "azurerm_resource_group" "main" {
  name     = "${var.naming_prefix}-rg"
  location = var.azure_region
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.naming_prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_cidr_range]
}