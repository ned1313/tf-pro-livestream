terraform {
  # Set a required minimum terraform version
  #required_version = ">= 1.14.0"
  # Configure required providers
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}