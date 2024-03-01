variable "indentifier" {
  description = "Уникальный идентификатор для инстанса базы данных."
  type        = string
}

variable "db_subnet_group_name" {
  description = "Список идентификаторов подсетей, в которых будет размещен RDS."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Список идентификаторов Security Group для доступа к RDS."
  type        = list(string)
}
variable "username" {
  description = "username_DB"
  type        = string
}
variable "password" {
  description = "password_DB"
  type        = string
}
           