
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


resource "aws_vpc" "RotemYehudai-dev-vpc" { 
  cidr_block = "192.168.1.0/24"
  tags = {
    "Name" = "RotemYehudai-dev-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.RotemYehudai-dev-vpc.id
  tags = {
    Name = "Rotem_igw"
  }
}


resource "aws_subnet" "RotemYehudai-k8s-subnet" {
  vpc_id     = aws_vpc.RotemYehudai-dev-vpc.id
  cidr_block = "192.168.1.0/27" 

  tags = {
    "Name" = "RotemYehudai-k8s-subnet"
  }
}



resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.RotemYehudai-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}






