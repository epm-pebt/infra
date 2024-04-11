variable "name" {
  description = "Name of the subnet group"
  type        = string
}

variable "vpc_id" {
  description = "Value of the VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ID List"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags to apply to the subnet group"
  type        = map(string)
  default     = {}
}