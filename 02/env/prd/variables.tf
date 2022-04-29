variable "env" {
  description = "env name"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "resource_count" {
  description = "resource count"
  type        = number
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "ebs_size" {
  description = "develop ebs's size"
  type        = number
}

variable "rds_storage" {
  description = "rds storage"
  type        = number
}

variable "db_engine" {
  description = "rds database engine"
  type        = string
}

variable "db_engine_version" {
  description = "rds database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "rds instance class"
  type        = string
}

variable "db_user_name" {
  description = "database user name"
  type        = string
}

variable "db_password" {
  description = "database user password"
  type        = string
  sensitive = true
}

variable "database_name" {
  description = "first database name"
  type        = string
}

variable "database_port" {
  description = "allow port number"
  type        = number
}
