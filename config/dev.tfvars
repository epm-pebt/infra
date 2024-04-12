#-------- General properties
name = "ecobytes-app"

#-------- VPC properties --------------------------------
cidr                 = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
tags = {
  App         = "ecobytes-app"
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
ami           = "ami-053b0d53c279acc90"
instance_type = "t2.micro"
instance_name = "webserver"

#--- VPC DB subnet group properties  --------------------------------
db_subnet_group_name = "db-subnet-group"

#----- RDS properties  --------------------------------
identifier                = "ecobytes-app-db"
engine                    = "postgres"
engine_version            = "12.15"
instance_class            = "db.t2.micro"
allocated_storage         = 20
storage_type              = "gp2"
port                      = "5432"
db_name                   = "testdbecobytesapp"
db_username               = "postgres"
db_password               = "postgres"
multi_az                  = false
security_rds_group_name   = "ecobytes-app-db-rds-sg"
skip_final_snapshot       = true
final_snapshot_identifier = "my-postgres-db-snapshot"
