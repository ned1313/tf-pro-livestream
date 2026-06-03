output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "bucket_name" {
  description = "Name of the S3 bucket."
  value       = aws_s3_bucket.this.id
}
