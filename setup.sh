#!/bin/bash
sudo apt update && apt upgrade -y && apt install npm -y && apt install curl -y && apt install -y docker-compose
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker
rm get-docker.sh
#install portainer
docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
# Install Node.js (using Node Version Manager - NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc  # or restart your terminal
nvm install v18.19.0
mkdir /home/odoo-addons
mkdir /home/odoo-config
# Create Docker network
docker network create mynetwork
# Run Redis container
docker run -d --name redis  -e vm.overcommit_memory=1 --network mynetwork redis
#sql install
docker run --network mynetwork -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:15 
# Run Odoo container
docker run -d --name odoo  -v /home/odoo-addons:/mnt/extra-addons -e cache_timeout=600 -e cache_type=redis -e cache_redis_hostname=redis -e cache_redis_port=6379 -e cache_redis_dbindex=1 --network mynetwork -p 8069:8069 -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=odoo odoo:latest
#proxy manager user Email address: admin@example.com
# Password: changeme
docker run -d --name=nginx-proxy-manager  -p 8181:8181  -p 8080:8080  -p 4443:4443  -v /docker/appdata/nginx-proxy-manager:/config:rw  jlesage/nginx-proxy-manager
# Build and Run Nuxt 3 container
#git clone https://github.com/your-nuxt3-repo.git  # replace with your Nuxt 3 repository
#cd your-nuxt3-repo
#docker build -t my-nuxt3-app .
#docker run -d --name my-nuxt3 --network mynetwork -p 3000:3000 my-nuxt3-app
