locals {
    user_data = <<-EOF
            #!/bin/bash
            sudo apt-get -y update
            sudo apt-get -y install wget
            sudo wget https://get.docker.com -O docker_install.sh  
            sudo sh docker_install.sh
            sudo usermod -aG docker $USER
            sudo service docker restart
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            EOF

}

resource "tls_private_key" "key_pair" {
  count     = var.ec2_key_name == "" ? 1 : 0
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair" {
  count = var.ec2_key_name == "" ? 1 : 0

  key_name   = "${var.name}-key"
  public_key = join("", tls_private_key.key_pair.*.public_key_openssh)

  tags = merge(
    { Name = "${var.name}.ssh-key"},
    var.tags
  )
}

resource "local_file" "ssh_private_key" {
  count = var.ec2_key_name == "" ? 1 : 0

  filename        = "${abspath(path.root)}/${var.name}-ssh-key.pem"
  file_permission = "0600"
  content         = join("", tls_private_key.key_pair.*.private_key_pem)
}


resource "aws_instance" "this" {
  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.ec2_key_name == "" ? join("", aws_key_pair.key_pair[*].key_name) : var.ec2_key_name
  user_data_replace_on_change = true
  subnet_id        = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data        = local.user_data

  provisioner "file" {
    source      = "${path.module}/templates/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml" 

    connection {
      type        = "ssh"
      user        = "ubuntu"  # user for connection
      private_key = join("", tls_private_key.key_pair.*.private_key_pem)
      host        = self.public_ip 
    }
  }

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}