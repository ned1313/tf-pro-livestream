variable "resource_group_name" {
  description = "Name of the resource group for the virtual network"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group for the virtual network"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_cidr_range" {
  description = "CIDR range for the virtual network"
  type        = string
}
