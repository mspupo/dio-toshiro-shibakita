#!/bin/sh

echo "Chamando o servidor 2..."

echo "Connectando ao servidor 1..."
/usr/bin/ssh -i "aws-mspupo-dev-key.pem" ubuntu@3.88.237.219

echo "Tornando superusuario..."
su 1234

echo "Atualizando o servidor 2..."
/usr/bin/apt-get update
/usr/bin/apt-get upgrade -y

echo "Instalando o Docker no servidor 2......."
/usr/bin/apt-get install ca-certificates curl gnupg lsb-release -y
/usr/bin/mkdir -p /etc/apt/keyrings
/usr/bin/curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

/usr/bin/apt-get update -y
/usr/bin/apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

/usr/bin/docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

echo "Juntando ao swarm..."
docker swarm join --token SWMTKN-1-4ldrd8cf3dffixzmgbuebpawk993f8yh4x2u43mpbwz1npb0uy-98p4wkhd69d6rvv0d1qty0uer 172.31.84.234:2377

echo "instalando nfs client..."
apt-get install nfs-common

mount -o v3 172.31.84.234:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data
