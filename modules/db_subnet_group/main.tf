resource "aws_db_subnet_group" "private_subnets" {
  name       = "private-db-subnets"
  subnet_ids = var.subnet_ids
}
