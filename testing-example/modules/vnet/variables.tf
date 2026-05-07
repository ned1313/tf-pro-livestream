variable "resource_group_name" {
  description = "Name of the target resource group for the virtual network."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,80}$", var.vnet_name))
    error_message = "vnet_name must be 1-80 chars and only contain letters, numbers, ., _, or -."
  }
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.address_space))
    error_message = "address_space must be valid CIDR notation."
  }
}

variable "topology" {
  description = "Topology mode for subnet composition: flat, hub_spoke, or three_tier."
  type        = string
  default     = "flat"

  validation {
    condition     = contains(["flat", "hub_spoke", "three_tier"], var.topology)
    error_message = "topology must be one of: flat, hub_spoke, three_tier."
  }
}

variable "flat_subnets" {
  description = "Subnets for flat topology."
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet in values(var.flat_subnets) : can(cidrnetmask(subnet.address_prefix))
    ])
    error_message = "Each flat_subnets address_prefix must be valid CIDR notation."
  }

  validation {
    condition     = var.topology != "flat" || length(var.flat_subnets) > 0
    error_message = "flat_subnets must contain at least one subnet when topology is flat."
  }
}

variable "hub_cidr" {
  description = "Hub subnet CIDR used in hub_spoke topology."
  type        = string
  default     = null

  validation {
    condition     = var.hub_cidr == null || can(cidrnetmask(var.hub_cidr))
    error_message = "hub_cidr must be null or valid CIDR notation."
  }

  validation {
    condition     = var.topology != "hub_spoke" || var.hub_cidr != null
    error_message = "hub_cidr is required when topology is hub_spoke."
  }
}

variable "spoke_subnets" {
  description = "Spoke subnets for hub_spoke topology."
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet in values(var.spoke_subnets) : can(cidrnetmask(subnet.address_prefix))
    ])
    error_message = "Each spoke_subnets address_prefix must be valid CIDR notation."
  }
}

variable "three_tier_subnets" {
  description = "Subnet CIDRs for three_tier topology."
  type = object({
    web  = string
    app  = string
    data = string
  })
  default = null

  validation {
    condition = var.three_tier_subnets == null || alltrue([
      can(cidrnetmask(var.three_tier_subnets.web)),
      can(cidrnetmask(var.three_tier_subnets.app)),
      can(cidrnetmask(var.three_tier_subnets.data))
    ])
    error_message = "three_tier_subnets must be null or contain valid web/app/data CIDRs."
  }

  validation {
    condition     = var.topology != "three_tier" || var.three_tier_subnets != null
    error_message = "three_tier_subnets is required when topology is three_tier."
  }
}

variable "tags" {
  description = "Tags applied to VNet and subnets."
  type        = map(string)
  default = {
    Environment = "test"
    Purpose     = "terraform-test"
  }
}

variable "expected_subnet_count" {
  description = "Optional expected subnet count for postcondition verification."
  type        = number
  default     = null

  validation {
    condition     = var.expected_subnet_count == null || (var.expected_subnet_count >= 1 && floor(var.expected_subnet_count) == var.expected_subnet_count)
    error_message = "expected_subnet_count must be null or a positive integer."
  }
}
