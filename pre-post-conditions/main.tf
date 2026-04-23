data "azurerm_resource_group" "main" {
  name = var.resource_group_name

  lifecycle {
    postcondition {
      condition     = length(self.tags) > 0 && contains(keys(self.tags), "Environment")
      error_message = "The resource group ${var.resource_group_name} does not have an Environment tag."
    }

    postcondition {
      condition     = self.tags["Environment"] == var.environment_tag
      error_message = "The resource group ${var.resource_group_name} does not have the correct Environment tag."
    }
  }
}


resource "azurerm_virtual_network" "main" {
  name                = "taconet"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = [var.vnet_address_space]

  lifecycle {
    precondition {
      condition     = var.region == data.azurerm_resource_group.main.location
      error_message = "The resource group ${var.resource_group_name} is not in the region ${var.region}"
    }
  }

  tags = {
    Environment = var.environment_tag
  }
}