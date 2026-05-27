# Module Usage Example

Here's the example module block:

```terraform
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
```

And here are the output block examples:

```terraform
output "vpc_id" {
  value = module.taco_app_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.taco_app_vpc.public_subnets
}
```
