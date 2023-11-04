# creating aws ec2 attached in a public subnet attaached with security group 
resource "aws_instance" "main" {
  ami                         = "ami-0dbc3d7bc646e8516"
  instance_type               = "t3.micro"
  user_data                   = file("${path.module}/userdata.tpl")
  security_groups             = [aws_security_group.my-sgp.id]
  subnet_id                   = aws_subnet.private.id
  count                       = 1
  associate_public_ip_address = false

  key_name = "awslinux"
  tags = {
    Name = "myec2"
  }
}

resource "aws_vpc" "my_vpc" {

  cidr_block = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "myec2vpc"
  }
}
# creating private subnet within vpc
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.16.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "mypriv_sub"
  }
}

#creating public subnet within vpc
resource "aws_subnet" "my_publicsubnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.16.12.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "mypub_sub"
  }
}
#route table for the public subnet
resource "aws_route_table" "my_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private-rtb"
  }
}
# Association between route table and public subnet
resource "aws_route_table_association" "pubasso" {
  subnet_id      = aws_subnet.my_publicsubnet.id
  route_table_id = aws_route_table.my_public.id
}

# Nat gateway for public subnet
resource "aws_nat_gateway" "my-gw" {
  allocation_id = aws_eip.one.id
  subnet_id     = aws_subnet.my_publicsubnet.id

  tags = {
    Name = "gw NAT"
  }


}

## Elastic ip for vpc .Ensuring proper ordering with an explicit dependency
# on the Internet Gateway for the VPC.
resource "aws_eip" "one" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.0.10"
  depends_on                = [aws_internet_gateway.gw]
}

# internet getway for the vpc to connect to internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "igw"
  }
}


# created template file to run user_data that lunches nginix 

data "template_file" "user_data" {
  template = "files/user_data.tpl"

}

