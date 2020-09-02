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

echo -------install docker-compose-------
# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose


echo -------allow docker-compose binary-------
# Allow binary
sudo chmod +x /usr/local/bin/docker-compose

#test: docker-compose -v && docker -v
echo -------install golang-------
# Install golang
#sudo apt-get update
#sudo apt-get -y upgrade
cd /tmp
wget https://dl.google.com/go/go1.13.12.linux-amd64.tar.gz
sudo tar -xvf go1.13.12.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
# Needs new environment variables for Go in ~/.profile
cd ~




echo -------donwload hyperledger fabric binary-------
mkdir fabric-samples
sudo chown -R $user:$user fabric-samples/

# Download Hyperledger Fabric binary
curl -sSL http://bit.ly/2ysbOFE | sudo bash -s -- 1.4.2 1.4.2 0.4.20
cd ~
#sudo chown -R $user:$user fabric-samples/

# add path
echo
echo "Add this to ~/.profile:"

#echo "export PATH=\$HOME/fabric-samples/bin:\$PATH"
#echo "export GOROOT=/usr/local/go"
#echo "export GOPATH=\$HOME/blockbench"
#echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH"
echo
echo "export PATH=\$HOME/fabric-samples/bin:\$PATH"
echo "export GOPATH=\$HOME/blockbench"
echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin"

#export PATH=$HOME/fabric-samples/bin:$PATH
#export GOPATH=$HOME/blockbench
#export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

echo
echo "update environment variables with:"
echo "source ~/.profile"
echo
echo "give docker sudo:"
echo "sudo usermod -aG docker \${USER}"
echo "su - \${USER}"

echo
echo "In case of missing permissions:"
echo "sudo chown -R \$USER:\$USER fabric-samples/"






