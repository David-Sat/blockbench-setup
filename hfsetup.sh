#!/bin/bash

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    python

# Install npm and node js

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
#npm install npm@5.6.0 -g
npm install npm@latest -g


sudo apt-get update
sudo apt upgrade -y



# Add docker official PGP key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update and install docker
sudo apt-get update
sudo apt-get install docker-ce

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


# Execute Docker without sudo
sudo usermod -aG docker ${USER}
su - ${USER}

# Allow binary
sudo chmod +x /usr/local/bin/docker-compose

#test: docker-composer -v && docker -v

# Install golang
sudo apt-get update
sudo apt-get -y upgrade
cd /tmp
wget https://dl.google.com/go/go1.12.17.linux-amd64.tar.gz
sudo tar -xvf go1.12.17.linux-amd64.tar.gz
sudo mv go /usr/local
# Needs new environment variables for Go in ~/.profile
cd ~




# Install git
sudo apt-get install git


# Download Hyperledger Fabric binary
sudo curl -sSL http://bit.ly/2ysbOFE | sudo bash -s -- 1.4.2 1.4.2 0.4.20
# add path

echo "Add this to ~/.profile"

echo "export PATH=/home/david/fabric-samples/bin:\$PATH"
echo "export GOROOT=/usr/local/go"
echo "export GOPATH=\$HOME/blockbench"
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH"


echo "source ~/.profile"







