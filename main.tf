provider "aws" {
  region = "us-east-1"
}

# Create out VPC (Virtual private cloud)

resource "aws_vpc" "airidas-application-deployment" {
  cidr_block = "10.3.0.0/16"

  tags = {
    Name = "airidas-application-deployment-vpc"
  }
}

# create internet gateway

resource "aws_internet_gateway" "airidas-ig" {
  vpc_id = "${aws_vpc.airidas-application-deployment.id}"

  tags = {
    Name = "airidas-ig"
  }
}

# create route table

resource "aws_route_table" "airidas-rt" {
  vpc_id = "${aws_vpc.airidas-application-deployment.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.airidas-ig.id}"
  }
}

# create module

module "application-tier" {
  name = "airidas-app"
  source = "./modules/application-tier"
  vpc_id = "${aws_vpc.airidas-application-deployment.id}"
  route_table_id = "${aws_route_table.airidas-rt.id}"
  cidr_block = "10.3.0.0/24"
  user_data=templatefile("./scripts/app_user_data.sh", {})
  ami_id = "ami-0aadcd8576538f786"
  map_public_ip_on_launch = true

  ingress = [{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "82.10.84.199/32"

  },{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "3.135.214.138/32"
  }]
}

