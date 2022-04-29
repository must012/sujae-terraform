data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = var.private_rds_subnets_id

  tags = {
    "Name" = "${var.env}-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage = var.rds_storage
  max_allocated_storage = var.rds_storage * 5
  availability_zone = data.aws_availability_zones.available.names[0]
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  skip_final_snapshot = true
  identifier = "${var.env}-rds"
  username = var.db_user_name
  password = var.db_password
  db_name = var.database_name
  port = var.database_port
  vpc_security_group_ids= [
    var.security_groups_id
  ]
}