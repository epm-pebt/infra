variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID подсетей"
  type        = list(string)
}