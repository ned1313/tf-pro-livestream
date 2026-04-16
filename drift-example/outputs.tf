output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "resource_group_id" {
  value = azurerm_resource_group.this.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.this.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}