# provider "aws" {
#   access_key = "AKIATQ3QMFNJ76ZLYXGT"
#   secret_key = "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"
#   region     = "us-east-1"
# }
terraform {
  backend "s3" {
    bucket = "terraform-state-250720241"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc_music_app"{
    source = "./modules/vpс"  
}

module "aws_security_group_ws"{
  source = "./modules/sg"
  name = "aws_security_group_ws"
  vpc_id = module.vpc_music_app.vpc_id
  ingress_port = [80, 22, 3000]
  
}

module "aws_security_group_rds"{
  source = "./modules/sg"
  name = "aws_security_group_rds"
  vpc_id = module.vpc_music_app.vpc_id
  ingress_port = [5432]
  egress_port = [0]
}

module "s3_buckets_public"{
  source        = "./modules/S3/public"
  bucket_public = "bucket-public-musicapp"
}

module "s3_buckets_privat" {
  source        = "./modules/S3/privat"
  bucket_privat = "bucket-private-musicapp2"
}
#--------------------------------------------------------------

resource "aws_key_pair" "test_aws" {
  key_name   = "aws"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3g+m7+AfHTf0wZksYlDWMXP6vwu6n35KTgyi+3v6dSEI3kYZOdPYNIisfs58BZCEDh7iD0A6tYF8TUUuL8v5NgcEg9fN7bCu/LXfG9mbcdz/iYxrME3aLW/1nuuTbwKVJcxKS17Z4wNUrC3WpUuiMnv/LqjQWJIXCsDLYnaZtyksRmKgyMgsokIuktA2yoZbW0MAvgqwn0FgIkckluMHnNdFhWilsEBdyWl/N1a8TZntrN0NR+9H1reUUr0tc93MK9aW60pSO6nRExC1rNEEy4TKvcy6uyTd3FejghKAoa5rtedX65jC2atCv3a2pqt/j8V7V8cndAamlkxKzzA1NUOwgrdJxJUeNwX5dVUCCsyqkOR9s2oinJTcMcHyCtT8a/1A9ug80/BSnpQgc9kRIQ3Qbd5BXpqnEYCNOMKlLfDBsLlpy6qXnvq4kxzSqirDPwEIxBxqXNOu136Dtp6O9k3f+zsfbevujhhncm73+XHb6LB4qB+OB40BMvSw7B8HAQffJxGH9MD9s6yJm4GF59l7RuNDq+td02f2X9XylJ9acEI8pzSDjZ5z1g70a5g9eWLerEyWOBuPvYdPWoILrnChyoVWQSMQu06JOUVQOI2CRWr8oimTFHFoBD6gD45O78OaSzssEkT/M2puOtg/kvsScZ4HBJ5nH7bsmch1gkw== user@PC-102985"
}

#--------------------------------------------------------------
resource "aws_instance" "web_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = aws_key_pair.test_aws.id
  subnet_id              = element(module.vpc_music_app.public_subnet_ids, 0)
  vpc_security_group_ids = module.aws_security_group_ws.security_group_ids
  user_data              = file("user_data.sh")
  connection {
    type        = "ssh"
    user        = "ubuntu"  # user for connection
    private_key = file("/var/lib/jenkins/.ssh/aws")
    host        = self.public_ip  # user public ip
  }
  provisioner "file" {
    source      = "./docker-compose.yml"  # path to local file 
    destination = "/home/ubuntu/docker-compose.yml"  # path need to copy
  }

  tags = {
    Name = "Web_server"
  }
}
#=======================================================================
module "db_subnet_group" {
  source = "./modules/db_subnet_group" 
    
  vpc_id     = module.vpc_music_app.vpc_id 
  subnet_ids = [element(module.vpc_music_app.private_subnet_ids, 0), element(module.vpc_music_app.public_subnet_ids, 0)] 
}
#=======================================================================

module "rds" {
  source      = "./modules/db/"
  indentifier = "my-postgres-db"
  db_subnet_group_name = module.db_subnet_group.aws_db_subnet_group_name
  username = "postgres"
  password = "postgres"
  vpc_security_group_ids = [module.aws_security_group_rds.security_group_id]
  }

