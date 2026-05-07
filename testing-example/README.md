# Terraform Testing Example

This example demonstrates Terraform native testing for an Azure VNet module that supports multiple network topologies and uses variable validations, preconditions, and postconditions.

## What is included

- `modules/resource-group`: small module used by integration tests to create an Azure resource group first.
- `modules/vnet`: topology-driven VNet module supporting `flat`, `hub_spoke`, and `three_tier` subnet composition.
- `tests/unit.tftest.hcl`: unit tests that use `mock_provider` and override resource-group data for plan-only tests.
- `tests/integration.tftest.hcl`: integration tests that create a real resource group and then run success/failure apply scenarios.

## Prerequisites

- Terraform `>= 1.12.0`
- Azure credentials for integration tests (`ARM_*` environment variables or Azure CLI login)

## Run tests

From this directory:

```powershell
# Run all tests
terraform test -test-directory=tests

# Run just unit tests
terraform test -filter 'tests\unit.tftest.hcl'
```

## Expected behavior

- Unit tests:
  - A valid `flat` topology plan succeeds.
  - Invalid input plans fail due to variable validation.
- Integration tests:
  - Resource group is created via module first.
  - A valid `three_tier` deployment succeeds.
  - A valid `flat` topology deployment succeeds
  - A postcondition failure case fails during apply, due to environment mismatch.
