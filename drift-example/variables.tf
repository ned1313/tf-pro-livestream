variable "location" {
  type        = string
  description = "Azure region for the drift example resources."
  default     = "eastus"
}

variable "name_prefix" {
  type        = string
  description = "Prefix used for Azure resource names."
  default     = "tf-pro-drift"
}

variable "project" {
  type        = string
  description = "Project tag value."
  default     = "TFP"
}

variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "dev"
}