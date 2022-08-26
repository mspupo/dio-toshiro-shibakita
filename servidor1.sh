#!/bin/sh

echo "Chamando o servidor 1..."

echo "Connectando ao servidor 1..."
/usr/bin/ssh -i "aws-mspupo-dev-key.pem" ubuntu@54.167.236.120

echo "Tornando superusuario..."
su 1234

echo "Atualizando o servidor 1..."
/usr/bin/apt-get update
/usr/bin/apt-get upgrade -y

echo "Instalando e configurando o banco de dados...."
/usr/bin/apt-get install default-mysql-server -y

/usr/bin/mysqladmin -u root password "1234"


echo "Instalando o Docker no servidor 1......."
/usr/bin/apt-get install ca-certificates curl gnupg lsb-release -y
/usr/bin/mkdir -p /etc/apt/keyrings
/usr/bin/curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

/usr/bin/apt-get update -y
/usr/bin/apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

docker swarm init

echo "Criando um servico Docker..."
docker service create --name web-server --replicas 3 -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

echo "Instalando nfs server..."
apt-get install nfs-server






