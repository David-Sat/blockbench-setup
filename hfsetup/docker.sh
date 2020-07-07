#!/bin/bash

user=$(logname)

echo -------apt-get update-------
sudo apt-get update
echo -------apt-get upgrade-------
sudo apt-get upgrade -y
echo -------apt-get install-------
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    python

echo -------install node js-------
# Install npm and node js
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
echo -------install npm-------
#npm install npm@5.6.0 -g
#sudo apt-get install npm
#npm install npm@latest -g


sudo apt-get remove docker docker-engine docker.io containerd runc


echo -------docker pgp key-------
# Add docker official PGP key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo -------add docker repository-------
# Add docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo -------docker install-------
# Update and install docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#echo -------docker sudo permissions-------
#sudo usermod -aG docker ${USER}
#su - ${USER}
cd ~

echo 
echo "give docker sudo:"
echo "sudo usermod -aG docker \${USER}"
echo "su - \${USER}"

echo
echo "In case of missing permissions:"
echo "sudo chown -R \$USER:\$USER fabric-samples/"






