locals {
  # Map t-shirt size to a concrete EC2 instance type.
  instance_size_map = {
    S = "t3.nano"
    M = "t3.micro"
    L = "t3.small"
  }

  instance_type = local.instance_size_map[var.instance_size]

  create_security_group = var.security_group_id == null
  security_group_id     = local.create_security_group ? aws_security_group.this[0].id : var.security_group_id

  # Build a stable for_each key per port.
  ingress_rules = {
    for port in var.listening_port : tostring(port) => port
  }

  common_tags = merge(
    {
      Name      = var.instance_name
      ManagedBy = "terraform"
      Module    = "ec2-instance"
    },
    var.tags,
  )
}

# Look up the most recent Amazon Linux 2023 AMI in the target region.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

# Optional security group. Created only when no existing security_group_id is supplied.
resource "aws_security_group" "this" {
  count = local.create_security_group ? 1 : 0

  name        = var.security_group_name
  description = "Security group for EC2 instance ${var.instance_name}"
  vpc_id      = data.aws_subnet.selected.vpc_id

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = var.security_group_name != null
      error_message = "security_group_name must be provided when security_group_id is null (a new security group will be created)."
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules

  security_group_id = local.security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
  description       = "Allow TCP ${each.value} from anywhere"

  tags = local.common_tags
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = local.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [local.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address

  tags        = local.common_tags
  volume_tags = local.common_tags

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }

  lifecycle {
    precondition {
      condition     = !(var.security_group_id != null && var.security_group_name != null)
      error_message = "security_group_name must be null when security_group_id is specified."
    }
  }
}
