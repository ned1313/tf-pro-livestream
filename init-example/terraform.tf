terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.4"
    }
  }
  backend "s3" {
    use_lockfile = true
  }
}