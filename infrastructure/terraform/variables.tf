variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ubuntu_ami" {
  description = "Ubuntu AMI ID"
  type        = string
  # Ubuntu 20.04 LTS AMI ID for us-east-1
  default     = "ami-0261755bbcb8c4a84"
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 instances"
  type        = string
}
