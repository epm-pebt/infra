variable "name" {
  description = "Name of the resource to create"
  type        = string
}
variable "vpc_id" {
  description = "ID VPC, in create Security Group"
  type        = string
}
variable "ingress_port" {
  description = "inbound trafic"
  type        = list(number)
  default = [80, 3000, 22, 5432]
}
variable "egress_port" {
  description = "oudbound trafic"
  type        = list(number)
  default = [0]
}
variable "tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
