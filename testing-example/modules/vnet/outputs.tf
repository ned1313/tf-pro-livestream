output "vnet_id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by logical subnet name."
  value = {
    for key, subnet in azurerm_subnet.this : key => subnet.id
  }
}

output "subnet_count" {
  description = "Number of subnets created by the selected topology."
  value       = length(azurerm_subnet.this)
}
