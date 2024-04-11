resource "aws_db_subnet_group" "private_subnets" {
  name        = var.name
  description = "Subnet group for database private access"
  subnet_ids  = var.subnet_ids

  tags = merge(
    { Name = "${var.name}" },
    var.tags
  )
}
