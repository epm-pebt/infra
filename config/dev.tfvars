#-------- General properties
prefix = "dev"
name   = "ecobites"

#-------- VPC properties --------------------------------
cidr                 = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
tags = {
  App         = "ecobites-app"
  Environment = "Development"
  Managed_by  = "Terraform"
}

#-----s3 bucket public properties --------------------------------

bucket_frontend_name = "frontend-ecobytes"
bucket_public        = true

# s3 bucket private flags 
bucket_private       = true
bucket_artifact_name = "artifact-ecobytes"

#----- Security Group properties  --------------------------------
security_group_name = "Webserver"

#----- EC2 instance properties  --------------------------------
# ami                = "ami-053b0d53c279acc90"
ami                = "ami-00beae93a2d981137"
instance_type      = "t2.micro"
instance_name      = "webserver"
ecr_registry_name  = "eco-bites"
ecr_registry_alias = "b3t0i4k1"
image_tag          = "IMAGE_TAG"

#--- VPC DB subnet group properties  --------------------------------
db_subnet_group_name = "db-subnet-group"

#----- RDS properties  --------------------------------
identifier        = "ecobites-app-db"
engine            = "postgres"
engine_version    = "12.15"
instance_class    = "db.t3.micro"
allocated_storage = 20
storage_type      = "gp2"
port              = "5432"
db_name           = "testdbecobitesapp"
db_username       = "postgres"
db_password       = "postgres"
# db_username               = "admin"
# db_password               = "admin"
multi_az                  = false
security_rds_group_name   = "ecobites-app-db-rds-sg"
skip_final_snapshot       = true
final_snapshot_identifier = "my-postgres-db-snapshot"
