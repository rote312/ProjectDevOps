//declaring the Sapak i am working with (the suppplier of the cloud)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
//Setting the region to New York
provider "aws" {
  region = "us-east-1"

}

//creating a vpc:
resource "aws_vpc" "RotemYehudai-dev-vpc" { //was called testing
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
  cidr_block = "192.168.1.0/27" //meaning the addresses are: 0-31

  tags = {
    "Name" = "RotemYehudai-k8s-subnet"
  }
}



resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.RotemYehudai-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}






