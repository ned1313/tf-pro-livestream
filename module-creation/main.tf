provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "taco_app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name                = "${var.naming_prefix}-vpc"
  cidr                = var.vpc_cidr
  azs                 = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
  public_subnets      = var.public_subnet_cidrs
  public_subnet_names = var.public_subnet_names

  tags = var.common_tags
}

module "web" {
  source = "./completed_module/ec2-instance"

  instance_name       = "web-01"
  instance_size       = "M"
  subnet_id           = module.taco_app_vpc.public_subnets[0]
  listening_port      = [80, 443]
  security_group_name = "web-01-sg"   # creates a new SG
}