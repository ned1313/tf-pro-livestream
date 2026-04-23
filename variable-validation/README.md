# Variable Validation Example (Objective 2A)

This example demonstrates variable type constraints and `validation` blocks using Azure resources.

## What it validates

- `example_prefix`: regex and length requirements
- `location`: allowed region list
- `environment`: allowed environment values
- `vnet_cidr`: CIDR syntax
- `subnet_count`: integer range

The `force_*_failure` toggles are included so you can show deterministic failures live without rewriting core values.

## Pass path

```powershell
terraform init
terraform plan
terraform apply -auto-approve
```

## Cleanup

```powershell
terraform destroy -auto-approve
```