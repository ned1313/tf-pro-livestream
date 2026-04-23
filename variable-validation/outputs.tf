output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the created virtual network."
  value       = azurerm_virtual_network.main.name
}

output "subnet_names" {
  description = "Names of created subnets."
  value       = azurerm_subnet.main[*].name
}