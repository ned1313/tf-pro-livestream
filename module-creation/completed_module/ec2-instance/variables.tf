variable "instance_name" {
  description = "Name to assign to the EC2 instance (used for the Name tag)."
  type        = string

  validation {
    condition     = length(var.instance_name) > 0 && length(var.instance_name) <= 64
    error_message = "instance_name must be between 1 and 64 characters."
  }
}

variable "instance_size" {
  description = "T-shirt size of the instance. Maps to: S=t3.nano, M=t3.micro, L=t3.small."
  type        = string

  validation {
    condition     = contains(["S", "M", "L"], var.instance_size)
    error_message = "instance_size must be one of: S, M, L."
  }
}

variable "subnet_id" {
  description = "ID of the subnet to launch the EC2 instance into."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]+$", var.subnet_id))
    error_message = "subnet_id must be a valid subnet ID (e.g., subnet-0123abcd)."
  }
}

variable "listening_port" {
  description = "List of TCP ports to allow in the security group ingress rules."
  type        = list(number)
  default     = []

  validation {
    condition     = alltrue([for p in var.listening_port : p >= 1 && p <= 65535])
    error_message = "All listening_port values must be between 1 and 65535."
  }
}

variable "security_group_id" {
  description = "ID of an existing security group to attach. If null, a new security group is created."
  type        = string
  default     = null

  validation {
    condition     = var.security_group_id == null || can(regex("^sg-[0-9a-f]+$", var.security_group_id == null ? "sg-0" : var.security_group_id))
    error_message = "security_group_id must be null or a valid security group ID (e.g., sg-0123abcd)."
  }

  validation {
    condition     = !(var.security_group_id != null && var.security_group_name != null)
    error_message = "security_group_id and security_group_name cannot both be supplied. Provide one or the other."
  }

  validation {
    condition = !(var.security_group_id == null && var.security_group_name == null)
    error_message = "Either security_group_id or security_group_name must be supplied. Provide one of the two."
  }
}

variable "security_group_name" {
  description = "Name to use for the new security group. Must be null when security_group_id is supplied."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
