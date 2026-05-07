locals {
  flat_map = {
    for subnet_name, subnet in var.flat_subnets : subnet_name => {
      address_prefix    = subnet.address_prefix
      service_endpoints = try(subnet.service_endpoints, [])
    }
  }

  hub_spoke_map = var.hub_cidr == null ? {} : merge(
    {
      hub = {
        address_prefix    = var.hub_cidr
        service_endpoints = []
      }
    },
    {
      for subnet_name, subnet in var.spoke_subnets : subnet_name => {
        address_prefix    = subnet.address_prefix
        service_endpoints = try(subnet.service_endpoints, [])
      }
    }
  )

  three_tier_map = var.three_tier_subnets == null ? {} : {
    web = {
      address_prefix    = var.three_tier_subnets.web
      service_endpoints = []
    }
    app = {
      address_prefix    = var.three_tier_subnets.app
      service_endpoints = []
    }
    data = {
      address_prefix    = var.three_tier_subnets.data
      service_endpoints = []
    }
  }

  topology_subnets = var.topology == "flat" ? local.flat_map : (
    var.topology == "hub_spoke" ? local.hub_spoke_map : local.three_tier_map
  )

  effective_expected_subnet_count = var.expected_subnet_count == null ? length(local.topology_subnets) : var.expected_subnet_count
}

data "azurerm_resource_group" "selected" {
  name = var.resource_group_name

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "Resource group ${var.resource_group_name} must include an Environment tag."
    }

    postcondition {
      condition     = lower(self.tags["Environment"]) == lower(var.tags["Environment"])
      error_message = "Resource group ${var.resource_group_name} has an unexpected Environment tag value."
    }
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.selected.name
  address_space       = [var.address_space]
  tags                = var.tags

  lifecycle {
    precondition {
      condition     = var.location == data.azurerm_resource_group.selected.location
      error_message = "VNet location must match the existing resource group location."
    }

    precondition {
      condition     = var.topology != "hub_spoke" || length(var.spoke_subnets) >= 2
      error_message = "hub_spoke topology requires at least two spoke_subnets."
    }

    postcondition {
      condition     = self.id != ""
      error_message = "Virtual network ID should be populated after apply."
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each = local.topology_subnets

  name                 = "${var.vnet_name}-${each.key}"
  resource_group_name  = data.azurerm_resource_group.selected.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  lifecycle {
    precondition {
      condition     = can(cidrhost(each.value.address_prefix, 0))
      error_message = "Every subnet prefix must be valid CIDR notation before subnet creation."
    }
  }
}
