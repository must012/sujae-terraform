# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.env}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Private Subnets
resource "aws_subnet" "public_subnet" {
  count             = var.sub_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.env}-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = var.sub_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.env}-private-subnet-${count.index + 1}"
  }
}

# RDS Private Subnets
resource "aws_subnet" "rds_private_subnet" {
  count             = var.sub_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.env}-rds-subnet-${count.index + 1}"
  }
}

# VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  tags = {
    "Name" = "${var.env}-s3-endpoint"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.env}-igw"
  }
}

# EIP for Nat Gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    "Name" = "${var.env}-ngw-eip"
  }
}

# Nat Gatway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    "Name" = "${var.env}-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "${var.env}-public-rtb"
  }
}

# Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.env}-private-rtb"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

## route associate
### vpc endpoint associate
resource "aws_vpc_endpoint_route_table_association" "public_rtb_endpoint" {
  route_table_id  = aws_route_table.public_rtb.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "privateRTbEndpoint" {
  route_table_id  = aws_route_table.private_rtb.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

### subnet associate
resource "aws_route_table_association" "public_rtb_association" {
  count          = var.sub_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "private_rtb_association" {
  count          = var.sub_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "rds_rtb_association" {
  count          = var.sub_count
  subnet_id      = aws_subnet.rds_private_subnet[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}
