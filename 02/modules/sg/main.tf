# public Seucurity Group
resource "aws_security_group" "public_sg_1" {
  name = "public-sg-1"
  description = "Allow all HTTP"
  vpc_id = var.vpc_id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
}

## private Security Group
resource "aws_security_group" "private_ec2_sg_1" {
  name = "private-ec2-sg-1"
  description = "Allow HTTP from ALB"
  vpc_id = var.vpc_id
  ingress = [ {
    cidr_blocks = null
    description = null
    from_port = 80
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    protocol = "tcp"
    security_groups = [ aws_security_group.public_sg_1.id ]
    self = false
    to_port = 80
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = null
    from_port = 0
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    protocol = "-1"
    security_groups = null
    self = false
    to_port = 0
  } ]
}

resource "aws_security_group" "private_rds_sg_1" {
  name = "private-rds-sg-01"
  description = "Allow HTTP from ALB"
  vpc_id = var.vpc_id
  ingress = [ {
    cidr_blocks = null
    description = null
    from_port = 3306
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    protocol = "tcp"
    security_groups = [aws_security_group.private_ec2_sg_1.id ]
    self = false
    to_port = 3306
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = null
    from_port = 0
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    protocol = "-1"
    security_groups = null
    self = false
    to_port = 0
  } ]
}