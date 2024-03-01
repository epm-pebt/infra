
resource "aws_db_instance" "db_instance" {
  identifier           = var.indentifier
  db_subnet_group_name = var.db_subnet_group_name
  engine               = "postgres"
  engine_version = "12.15"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  username             = var.username
  password             = var.password
  db_name              = "test_db_music_app"
  port                 = 5432
  #parameter_group_name = "default.postgres15"
  multi_az             = false
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = false
  skip_final_snapshot = false
}