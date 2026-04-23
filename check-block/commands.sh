# Provision the infrastructure and run a plan to trigger the checks
terraform init
terraform apply -auto-approve

# View the checks in state
terraform show -json | jq -r '.checks[] | [.address.kind, .address.to_display, .status]'
terraform show -json | jq -r '.checks[] | select(.address.kind==\"check\") | [.address.to_display, .status]'

# Run a plan to fire off the checks
terraform plan

# Add a new rule to the NSG
az network nsg rule create -g 'check-block-example' -n allow_ssh --nsg-name 'check-example' --priority 110 --destination-port-ranges '22' --protocol Tcp --description 'Allow SSH'

# Shut down the VM
az vm deallocate -g 'check-block-example' -n 'check-vm'

# Run a plan again to see the checks fail
terraform plan -out plan.tfplan

# Checks will fail and you can see the details in the plan output
terraform show -json plan.tfplan | jq -r '.checks[] | select(.address.kind==\"check\") | [.address.to_display, .status]'

# Remove the NSG rule
az network nsg rule delete -g 'check-block-example' --nsg-name 'check-example' -n allow_ssh

# Power on the VM
az vm start -g 'check-block-example' -n 'check-vm'

# Run a plan again to see the checks pass
terraform plan
