variable "naming_prefix" {
  description = "Prefix to use for resource names"
  type        = string
}

variable "azure_region" {
  description = "Azure region for resource deployment"
  type        = string
}

variable "vnet_cidr_range" {
  description = "CIDR range for the virtual network"
  type        = string
}
