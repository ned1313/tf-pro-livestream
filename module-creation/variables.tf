variable "aws_region" {
  description = "Region of AWS to use"
  type        = string
  default     = "us-east-2"
}

variable "naming_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "tfpro-livestream"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "public_subnet_names" {
  description = "List of names for public subnets"
  type        = list(string)
  default     = ["public-subnet-1", "public-subnet-2"]
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "tfpro-livestream"
  }
}