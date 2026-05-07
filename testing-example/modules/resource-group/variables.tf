variable "name" {
  description = "Name of the Azure resource group."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._()-]{1,90}$", var.name))
    error_message = "name must be 1-90 chars and only contain letters, numbers, ., _, (, ), or -."
  }
}

variable "location" {
  description = "Azure region for the resource group."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "tags" {
  description = "Tags applied to the resource group."
  type        = map(string)
  default = {
    Environment = "test"
    Purpose     = "terraform-test"
  }
}
