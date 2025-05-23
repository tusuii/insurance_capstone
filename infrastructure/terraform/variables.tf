variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "ubuntu_ami" {
  description = "Ubuntu AMI ID"
  type        = string
  # Ubuntu 20.04 LTS AMI ID for us-east-1
  default     = "ami-0261755bbcb8c4a84"
}

