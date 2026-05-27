output "instance_id" {
  description = "ID of the created EC2 instance."
  value       = aws_instance.this.id
}

output "security_group_id" {
  description = "ID of the security group attached to the instance (created or supplied)."
  value       = local.security_group_id
}

output "public_ip_address" {
  description = "Public IPv4 address of the instance, if one was assigned."
  value       = aws_instance.this.public_ip
}

output "public_hostname" {
  description = "Public DNS hostname of the instance, if one was assigned."
  value       = aws_instance.this.public_dns
}
