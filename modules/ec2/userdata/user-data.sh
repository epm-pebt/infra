| #!/bin/bash

sudo apt-get -y update
sudo apt-get -y install wget
sudo wget https://get.docker.com -O docker_install.sh  
sudo sh docker_install.sh
sudo usermod -aG docker $USER
sudo service docker restart
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose