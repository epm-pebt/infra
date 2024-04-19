terraform {
  backend "s3" {
    bucket               = "terraform-state-250720243"
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "tf"
  }
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = var.name
  cidr                 = var.cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "security_group_webserver" {
  source       = "./modules/sg"
  name         = var.security_group_name
  vpc_id       = module.vpc.vpc_id
  ingress_port = [80, 22, 3000]
  tags         = var.tags
}

module "aws_security_group_rds" {
  source       = "./modules/sg"
  name         = var.security_rds_group_name
  vpc_id       = module.vpc.vpc_id
  ingress_port = [5432]
  egress_port  = [0]
  tags         = var.tags
}
module "ec2_instance_webserver" {
  source                 = "./modules/ec2"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instance_type
  instance_name          = var.instance_name
  vpc_security_group_ids = module.security_group_webserver.security_group_ids
  subnet_id              = element(module.vpc.public_subnet_ids, 0)
  tags                   = var.tags
}
module "db_subnet_group" {
  source     = "./modules/db_subnet_group"
  name       = var.db_subnet_group_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [element(module.vpc.private_subnet_ids, 0), element(module.vpc.private_subnet_ids, 1)]
  tags       = var.tags
}

module "rds" {
  source                    = "./modules/db/"
  identifier                = var.identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  port                      = var.port
  db_name                   = var.db_name
  db_subnet_group_name      = module.db_subnet_group.aws_db_subnet_group_name
  username                  = var.db_username
  password                  = var.db_password
  vpc_security_group_ids    = [module.aws_security_group_rds.security_group_id]
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  tags                      = var.tags
}
module "bucket_artifact" {
  source         = "./modules/s3"
  name           = var.name
  bucket_private = var.bucket_private
  bucket         = var.bucket_artifact_name
  tags           = var.tags
}
module "bucket_frontend" {
  source        = "./modules/s3"
  name          = var.name
  bucket_public = var.bucket_public
  bucket        = var.bucket_frontend_name
  tags          = var.tags
}
