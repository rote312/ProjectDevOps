terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "testing" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "elram-naim-dev-vpc"
  }
}
resource "aws_subnet" "Subnet_Web" {
  vpc_id     = aws_vpc.testing.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "elram-naim-k8s-subnet"
  }
}

resource "aws_network_interface" "test" {
  subnet_id   = aws_subnet.Subnet_Web.id
  private_ips = ["10.0.0.10"]
  tags = {
    "Name" = "nic_web"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
  # associate_public_ip_address = true

  credit_specification {
    cpu_credits = "unlimited"

  }
  tags = {
    Name = "elram"
  }

}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.testing.id

  tags = {
    Name = "IGW"
  }
}
resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


}
