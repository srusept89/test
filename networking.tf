#Networking
#Create VPC
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main VPC"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-IGW"
  }
}
#Create Public subnet
resource "aws_subnet" "web-subnet-public" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1a"
  }
}
#Create Private subnets
resource "aws_subnet" "web-subnet-1" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-web-1a"
  }
}
resource "aws_subnet" "web-subnet-2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-web-1b"
  }
}
resource "aws_subnet" "app-subnet-1" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-app-1a"
  }
}
resource "aws_subnet" "app-subnet-2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-app-1b"
  }
}
#create db subnet
# Create Database Private Subnet
resource "aws_subnet" "database-subnet-1" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-db-1a"
  }
}

resource "aws_subnet" "database-subnet-2" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-db-1b"
  }
}
# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}
