variable "example_prefix" {
  description = "Prefix used in resource names for this example."
  type        = string
  default     = "tf-pro-varval"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.example_prefix)) && length(var.example_prefix) >= 6 && length(var.example_prefix) <= 20
    error_message = "example_prefix must be 6-20 chars, lowercase, and only contain a-z, 0-9, or -. Set force_prefix_failure=false to pass."
  }
}

variable "location" {
  description = "Azure region used for deployment."
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(local.allowed_regions, var.location)
    error_message = "location must be one of: ${join(", ", local.allowed_regions)}."
  }
}

variable "environment" {
  description = "Environment label for tags."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test, or prod. Set force_environment_failure=false to pass."
  }
}

variable "vnet_cidr" {
  description = "CIDR range for the demo virtual network."
  type        = string
  default     = "10.42.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vnet_cidr))
    error_message = "vnet_cidr must be valid CIDR notation. Set force_cidr_failure=false to pass."
  }
}

variable "subnet_count" {
  description = "How many subnets to create from vnet_cidr."
  type        = number
  default     = 2

  validation {
    condition     = var.subnet_count >= 1 && var.subnet_count <= 4 && floor(var.subnet_count) == var.subnet_count
    error_message = "subnet_count must be an integer between 1 and 4. Set force_subnet_count_failure=false to pass."
  }
}

variable "default_tags" {
  description = "Default tags to use for the resource group."
  type        = map(string)
  default = {
    project     = "tf-pro-exam"
    environment = "dev"
    objective   = "2A-variable-validation"
  }

  validation {
    condition = alltrue([
      for key in keys(var.default_tags) : can(regex("^[A-Za-z0-9_.-]+$", key))
    ])
    error_message = "Tag keys must only contain letters, numbers, underscore (_), period (.), or hyphen (-)."
  }
}