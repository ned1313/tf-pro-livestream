output "s3_bucket_name" {
  value = aws_s3_bucket.this.id
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "my_output" {
  value = "HI THERE"
}