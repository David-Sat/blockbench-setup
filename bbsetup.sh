#!/bin/bash  

INSTALL_DIR=$HOME

# Git clone benchmark
if [ ! -d $HOME/blockbench ]; then
    git clone https://github.com/ooibc88/blockbench.git
fi


# install c++ libraries
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install g++ curl
sudo apt-get -y install autoconf
sudo apt-get -y install autogen
sudo apt-get -y install libtool
sudo apt-get -y install libcurl4-openssl-dev
sudo apt-get -y install build-essential

sudo apt-get -y install cmake # unsure if needed

sudo npm install --g lerna


# restclient install

if [ ! -d $HOME/restclient-cpp/ ]; then
    git clone https://github.com/mrtazz/restclient-cpp.git
else 
    cd restclient-cpp
fi


./autogen.sh
./configure
sudo make install


# Node.js libraries
cd ~/blockbench/src/micro
npm install web3
npm install zipfian
npm install bignumber.js
npm install fabric-client
npm install fabric-ca-client
npm install fabric-network
cd ~


# Install Hyperledger
cd ~/blockbench/benchmark/hyperledger
chmod +x install.sh
./install.sh


# Make drivers

echo "cd ~/blockbench/src/macro/kvstore | make"




