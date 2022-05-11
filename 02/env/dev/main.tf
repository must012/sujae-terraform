module "network" {
  source    = "../../modules/network"
  vpc_cidr  = var.vpc_cidr
  sub_count = var.resource_count
  env       = var.env
}

module "sg" {
  source = "../../modules/sg"
  vpc_id = module.network.vpc_id
}

module "ec2" {
  source          = "../../modules/ec2"
  env             = var.env
  ec2_count       = var.resource_count
  instance_type   = var.instance_type
  private_subnets = module.network.private_subnets_id
  private_sg      = module.sg.private_ec2_sg_id
  ebs             = var.ebs_size
  depends_on = [
    module.network
  ]
}

module "alb" {
  source            = "../../modules/alb"
  env               = var.env
  vpc_id            = module.network.vpc_id
  public_sg_id      = module.sg.public_sg_id
  public_subnets_id = module.network.public_subnets_id
  ec2_count         = var.resource_count
  ec2_id            = module.ec2.ec2_id
}

module "rds" {
  source                 = "../../modules/rds"
  env                    = var.env
  private_rds_subnets_id = module.network.rds_private_subnets_id
  rds_storage            = var.rds_storage
  db_engine              = var.db_engine
  db_engine_version      = var.db_engine_version
  db_instance_class      = var.db_instance_class
  db_user_name           = var.db_user_name
  db_password            = var.db_password
  database_name          = var.database_name
  database_port          = var.database_port
  security_groups_id     = module.sg.private_rds_sg_id
}

module "s3" {
  source = "../../modules/s3"
  env    = var.env
  endpoint_id = module.network.endpoint_id
}
