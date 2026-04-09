variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "s3_bucket_prefix" {
  type        = string
  description = "Name prefix for the S3 bucket."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources."
  default     = {}
}

variable "web_page_message" {
  type        = string
  description = "Message to display on the web page."
  default     = "TF Pro Rocks"
}
