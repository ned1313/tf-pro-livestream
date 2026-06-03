module "bucket" {
  source = "../bucket-module"

  name_prefix        = var.name_prefix
  versioning_status  = var.versioning_status
}