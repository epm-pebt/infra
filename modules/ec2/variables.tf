variable "ami" {
  description = "The id of the AMI to use"
  type        = string
}

variable "instance_type" {
  description = "The instance type of the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "ec2_key_name" {
  description = "Name of the SSH keypair to use in AWS"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to resource."
  type        = map(string)
  default     = {}
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