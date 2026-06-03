variable "name_prefix" {
  description = "Prefix applied to resource names and tags."
  type        = string
  default     = "module-refactor"
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