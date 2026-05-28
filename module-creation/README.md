# Module Creation Example

We are going to create a module to deploy and EC2 instance with a security group that allows traffic on the specified ports.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 6.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (6.46.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) (resource)
- [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_vpc_security_group_ingress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) (resource)
- [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) (data source)
- [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name)

Description: Name to assign to the EC2 instance (used for the Name tag).

Type: `string`

### <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size)

Description: T-shirt size of the instance. Maps to: S=t3.nano, M=t3.micro, L=t3.small.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: ID of the subnet to launch the EC2 instance into.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address)

Description: Whether to associate a public IP address with the instance.

Type: `bool`

Default: `true`

### <a name="input_listening_port"></a> [listening\_port](#input\_listening\_port)

Description: List of TCP ports to allow in the security group ingress rules.

Type: `list(number)`

Default: `[]`

### <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id)

Description: ID of an existing security group to attach. If null, a new security group is created.

Type: `string`

Default: `null`

### <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name)

Description: Name to use for the new security group. Must be null when security\_group\_id is supplied.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Additional tags to apply to all resources created by this module.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id)

Description: ID of the created EC2 instance.

### <a name="output_public_hostname"></a> [public\_hostname](#output\_public\_hostname)

Description: Public DNS hostname of the instance, if one was assigned.

### <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address)

Description: Public IPv4 address of the instance, if one was assigned.

### <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id)

Description: ID of the security group attached to the instance (created or supplied).

