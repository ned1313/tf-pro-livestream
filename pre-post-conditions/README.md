# Pre/Post Conditions Example (Objective 2A)

Start by creating two resource groups in two different regions:

```bash
az group create --name sopes-east --location eastus --tags "Environment=Production"
az group create --name sopes-west --location westus --tags "Environment=Production"
```

Initialize the terraform configuration

```bash
terraform init
```

The region set in the `terraform.tfvars` is `eastus`. Run a terraform plan with the resource group in the `westus` region to see the data source postcondition fail:

```bash
terraform plan -var="resource_group_name=sopes-west"
```

To see the precondition in the virtual network block fail, generate a plan with the environment set to `Development`:

```bash
terraform plan -var="environment_tag=Development"
```

Now run a plan using the settings in the `terraform.tfvars` and all the conditions should pass

```bash
terraform plan
```

When you're done, delete the resource groups to clean up:

```bash
az group delete --resource-group sopes-east --yes
az group delete --resource-group sopes-west --yes
```
