provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "Vpc-Terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Vpc-Terraform"
  }
}

resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.Vpc-Terraform.id

  tags = {
    Name = "igw-terraform"
  }
}

resource "aws_subnet" "public-subnet-terraform" {
  vpc_id     = aws_vpc.Vpc-Terraform.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet-terraform"
  }
}

resource "aws_route_table" "RT-Terraform" {
  vpc_id = aws_vpc.Vpc-Terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terraform.id

  }
  tags = {
    Name = "RT-Terraform"
  }
}

resource "aws_route_table_association" "RTA-Terraform" {
  subnet_id      = aws_subnet.public-subnet-terraform.id
  route_table_id = aws_route_table.RT-Terraform.id
}

resource "aws_security_group" "sg-Terraform" {
  name        = "allow-all"
  description = "allowing all ports"
  vpc_id      = aws_vpc.Vpc-Terraform.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-Terraform"
  }
}