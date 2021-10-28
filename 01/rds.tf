resource "aws_db_subnet_group" "testSubnetGroup" {
  name = "test"
  subnet_ids = [ 
    aws_subnet.privateRDSSubnet1.id,
    aws_subnet.privateRDSSubnet2.id
  ]

  tags = {
    "Name" = "test-subnet-group"
  }

}

resource "aws_db_instance" "testDB" {
  allocated_storage = 20
  max_allocated_storage = 50
  availability_zone = "ap-northeast-1a"
  db_subnet_group_name = aws_db_subnet_group.testSubnetGroup.name
  engine = "mariadb"
  engine_version = "10.5"
  instance_class = "db.t3.small"
  skip_final_snapshot = true
  identifier = "test-maridb"
  username = "root"
  password = var.db_password
  name = "testDB"
  port = "3306"
}

