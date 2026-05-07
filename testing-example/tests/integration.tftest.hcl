provider "azurerm" {
  features {}
}

run "create_resource_group" {
  command = apply

  module {
    source = "./tests/fixtures/create-rg"
  }

  variables {
    resource_group_name = "tf-test-${formatdate("YYMMDDhhmmss", timestamp())}-rg"
    location            = "eastus"
    tags = {
      Environment = "test"
      Purpose     = "integration"
    }
  }
}

run "apply_vnet_success" {
  command = apply

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name        = run.create_resource_group.resource_group_name
    location                   = run.create_resource_group.resource_group_location
    vnet_name                  = "tf-test-vnet-three-tier"
    topology                   = "three_tier"
    address_space              = "10.94.0.0/16"
    tags = {
      Environment = "test"
      Purpose     = "integration"
    }
    flat_subnets  = {}
    hub_cidr      = null
    spoke_subnets = {}
    three_tier_subnets = {
      web  = "10.94.1.0/24"
      app  = "10.94.2.0/24"
      data = "10.94.3.0/24"
    }
    expected_subnet_count = 3
  }

  assert {
    condition     = var.expected_subnet_count == output.subnet_count
    error_message = "Expected ${var.expected_subnet_count} subnets, but found ${output.subnet_count}."
  }
}

run "apply_vnet_flat_topology_success" {
  command = apply

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = run.create_resource_group.resource_group_name
    location            = run.create_resource_group.resource_group_location
    vnet_name           = "tf-test-vnet-precondition-fail"
    address_space       = "10.95.0.0/16"
    topology            = "flat"
    flat_subnets = {
      app = {
        address_prefix = "10.95.1.0/24"
      }
    }
    hub_cidr                     = null
    spoke_subnets                = {}
    three_tier_subnets           = null
    tags = {
      Environment = "test"
      Purpose     = "integration"
    }
  }
}

run "apply_vnet_postcondition_failure" {
  command = plan

  module {
    source = "./modules/vnet"
  }

  variables {
    resource_group_name = run.create_resource_group.resource_group_name
    location            = run.create_resource_group.resource_group_location
    vnet_name           = "tf-test-vnet-postcondition-fail"
    address_space       = "10.96.0.0/16"
    topology            = "flat"
    flat_subnets = {
      app = {
        address_prefix = "10.96.1.0/24"
      }
      data = {
        address_prefix = "10.96.2.0/24"
      }
    }
    hub_cidr                     = null
    spoke_subnets                = {}
    three_tier_subnets           = null
    tags = {
      Environment = "wrong-value"
      Purpose     = "integration"
    }
  }

  expect_failures = [data.azurerm_resource_group.selected]
}

