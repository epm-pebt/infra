
resource "aws_db_instance" "db_instance" {
  identifier           = var.identifier
  db_subnet_group_name = var.db_subnet_group_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  username             = var.username
  password             = var.password
  db_name              = var.db_name
  port                 = var.port
  multi_az             = var.multi_az
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = merge(
    { Name = "${var.identifier}-db-instance" },
    var.tags
  )

}