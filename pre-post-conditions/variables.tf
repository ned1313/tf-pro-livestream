variable "region" {
  type        = string
  default     = "eastus"
  description = "Azure region to deploy resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which to create resources."
}

variable "vnet_address_space" {
  type        = string
  description = "Address space for the virtual network."
  default     = "10.0.0.0/16"
}

variable "environment_tag" {
  type        = string
  description = "Tag to use for Environment"
}