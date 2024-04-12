variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags for all resources as identifier"
  type        = map(string)
  default     = {}
}

#-------- Bucket properties --------------------------------

variable "bucket_artifact_name" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = null
}

variable "bucket_private" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = bool
  default     = false
}

variable "bucket_public" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = bool
  default     = false
}

variable "bucket_frontend_name" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = true
}

#----- Networking parameters --------------------------------

variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
#----- Networking parameters --------------------------------

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = ""
}

#------ Ec2 instance properties -------------------------------
variable "instance_name" {
  description = "Name of the instance"
  type        = string
  default     = ""
}

variable "ec2_key_name" {
  description = "Name of the key pair to use for the instance"
  type        = string
  default     = ""
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = ""
}

variable "userdata" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

#------ DB subnet group properties -------------------------------
variable "db_subnet_group_name" {
  description = "The VPC DB Subnet ID group name to launch in"
  type        = string
}

#------ RDS properties ---------------------------------------
variable "identifier" {
  description = "Unique identifier for the database instance."
  type        = string
  default     = null
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
  default     = null
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Name of the DB snapshot created when skip_final_snapshot is false"
  type        = string
  default     = null
}

variable "security_rds_group_name" {
  description = "Name of the security group to associate with"
  type        = string
}

