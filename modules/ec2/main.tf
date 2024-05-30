locals {
  user_data = <<-EOF
            #!/bin/bash
            sudo yum -y update
            sudo yum install -y docker
            sudo yum install -y libxcrypt-compat   #library for docker-compose execution
            sudo service docker start
            sudo usermod -a -G docker ec2-user
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            EOF
}

resource "local_file" "docker_compose" {
  filename        = "${path.module}/docker-compose.yaml"
  file_permission = "0644"
  content = templatefile("${path.module}/templates/docker-compose.yaml", {
    db_username        = var.db_username,
    db_password        = var.db_password,
    db_name            = var.db_name,
    ecr_registry_name  = var.ecr_registry_name
    ecr_registry_alias = var.ecr_registry_alias
    image_tag          = var.image_tag
  })
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  user_data_replace_on_change = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  user_data                   = local.user_data
  iam_instance_profile        = aws_iam_instance_profile.ssm.name

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}

resource "aws_iam_role" "ssm" {
  name = "ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_access"
  description = "Policy to allow EC2 instance to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::dev-artifact-ecobytes",
          "arn:aws:s3:::dev-artifact-ecobytes/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_instance_profile" "ssm" {
  name = "ssm"
  role = aws_iam_role.ssm.name
}
