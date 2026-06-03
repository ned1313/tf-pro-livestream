data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr_block

  azs            = [data.aws_availability_zones.available.names[0]]
  public_subnets = [var.public_subnet_cidr_block]

  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = var.name_prefix
  force_destroy = true

  tags = {
    Name = "${var.name_prefix}-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_status
  }
}
