# VPC
resource "aws_vpc" "test" {
  cidr_block = "159.0.0.0/16"
  tags = {
    "Name" = "terraform-test-vpc"
  }
}

# VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.test.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

# Subnets
## public subnet
resource "aws_subnet" "publicSubnet1" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "test-public-subnet-01"
  }
}

resource "aws_subnet" "publicSubnet2" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "test-public-subnet-02"
  }
}

## private ec2 subnet
resource "aws_subnet" "privateEC2Subnet1" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "test-private-ec2-subnet-01"
  }
}

resource "aws_subnet" "privateEC2Subnet2" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "test-private-ec2-subnet-02"
  }
}

## private rds subnet
resource "aws_subnet" "privateRDSSubnet1" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.4.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "test-private-rds-subnet-01"
  }
}

resource "aws_subnet" "privateRDSSubnet2" {
  vpc_id = aws_vpc.test.id
  cidr_block = "159.0.5.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "test-private-rds-subnet-02"
  }
}

# IGW
resource "aws_internet_gateway" "testIGW" {
  vpc_id = aws_vpc.test.id
  tags = {
    "Name" = "testIGW"
  }
}

# Route Table
resource "aws_route_table" "testPublicRTb" {
  vpc_id = aws_vpc.test.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW.id
  }

  tags = {
    "Name" = "test-public-rtb"
  }
}

resource "aws_route_table" "testPrivateRTb" {
  vpc_id = aws_vpc.test.id
  tags = {
    "Name" = "test-private-rtb"
  }
}

## route
### vpc endpoint associate
resource "aws_vpc_endpoint_route_table_association" "publicRTbEndpoint" {
  route_table_id = aws_route_table.testPublicRTb.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "privateRTbEndpoint" {
  route_table_id = aws_route_table.testPrivateRTb.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

### subnet associate
resource "aws_route_table_association" "publicRTbAssociation01" {
  subnet_id = aws_subnet.publicSubnet1.id
  route_table_id = aws_route_table.testPublicRTb.id
}

resource "aws_route_table_association" "publicRTbAssociation02" {
  subnet_id = aws_subnet.publicSubnet2.id
  route_table_id = aws_route_table.testPublicRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation01" {
  subnet_id = aws_subnet.privateEC2Subnet1.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation02" {
  subnet_id = aws_subnet.privateEC2Subnet2.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation03" {
  subnet_id = aws_subnet.privateRDSSubnet1.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation04" {
  subnet_id = aws_subnet.privateRDSSubnet2.id
  route_table_id = aws_route_table.testPrivateRTb.id
}