mock_provider "azurerm" {
  override_data {
    target = data.azurerm_resource_group.selected
    values = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg"
      name     = "mock-rg"
      location = "eastus"
      tags = {
        Environment = "test"
      }
    }
  }
}

run "plan_flat_topology_succeeds" {
  command = plan

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = "mock-rg"
    location            = "eastus"
    vnet_name           = "unit-flat-vnet"
    address_space       = "10.90.0.0/16"
    topology            = "flat"
    flat_subnets = {
      app = {
        address_prefix = "10.90.1.0/24"
      }
      data = {
        address_prefix = "10.90.2.0/24"
      }
    }
  }
}

run "plan_fails_invalid_topology" {
  command = plan

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = "mock-rg"
    location            = "eastus"
    vnet_name           = "unit-invalid-topology"
    address_space       = "10.91.0.0/16"
    topology            = "mesh"
    flat_subnets = {
      app = {
        address_prefix = "10.91.1.0/24"
      }
    }
  }

  expect_failures = [var.topology]
}

run "plan_fails_invalid_address_space" {
  command = plan

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = "mock-rg"
    location            = "eastus"
    vnet_name           = "unit-invalid-cidr"
    address_space       = "10.999.0.0/16"
    topology            = "flat"
    flat_subnets = {
      app = {
        address_prefix = "10.92.1.0/24"
      }
    }
  }

  expect_failures = [var.address_space]
}

run "plan_fails_missing_flat_subnets" {
  command = plan

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = "mock-rg"
    location            = "eastus"
    vnet_name           = "unit-missing-subnets"
    address_space       = "10.93.0.0/16"
    topology            = "flat"
    flat_subnets        = {}
  }

  expect_failures = [var.flat_subnets]
}
