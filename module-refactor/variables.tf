variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-2"
}

variable "name_prefix" {
  description = "Prefix applied to resource names and tags."
  type        = string
  default     = "module-refactor"
}

variable "vpc_cidr_block" {
  description = "CIDR range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR range for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "versioning_status" {
  description = "Versioning state for the S3 bucket."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "versioning_status must be one of: Enabled, Suspended, Disabled."
  }
}
