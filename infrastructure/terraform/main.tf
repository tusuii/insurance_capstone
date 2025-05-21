provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "insurance_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "insurance-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "insurance_igw" {
  vpc_id = aws_vpc.insurance_vpc.id

  tags = {
    Name = "insurance-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.insurance_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "insurance-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.insurance_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.insurance_igw.id
  }

  tags = {
    Name = "insurance-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Key Pair
resource "aws_key_pair" "insurance_key" {
  key_name   = "insurance-key"
  public_key = var.ssh_public_key
}

# Master Node
resource "aws_instance" "master" {
  ami           = var.ubuntu_ami
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.insurance_key.key_name

  vpc_security_group_ids = [aws_security_group.insurance_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "insurance-master"
    Role = "master"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname master
              EOF
}

# Worker Nodes
resource "aws_instance" "workers" {
  count         = 2
  ami           = var.ubuntu_ami
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.insurance_key.key_name

  vpc_security_group_ids = [aws_security_group.insurance_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "insurance-worker-${count.index + 1}"
    Role = "worker"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname worker-${count.index + 1}
              EOF
}
