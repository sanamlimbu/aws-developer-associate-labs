variable "project_name" {
  description = "Name used for tagging and identifying resources."
  type        = string
  default     = "aws-developer-associate-labs"
}

variable "aws_region" {
  description = "AWS region to deploy all resources."
  type        = string
  default     = "ap-southeast-2"
}