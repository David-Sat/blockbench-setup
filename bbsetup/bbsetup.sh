#!/bin/bash  
cd ~
INSTALL_DIR=$HOME
user=$(logname)

# Git clone benchmark
if [ ! -d $HOME/blockbench ]; then
    git clone https://github.com/ooibc88/blockbench.git
fi
cd ~
sudo chown -R $user:$user blockbench/

# install c++ libraries
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install g++ curl
sudo apt-get -y install autoconf
sudo apt-get -y install autogen
sudo apt-get -y install libtool
sudo apt-get -y install libcurl4-openssl-dev
sudo apt-get -y install build-essential

sudo apt-get install autotools-dev
sudo apt-get install libtool m4 automake

sudo apt-get -y install cmake # unsure if needed

sudo npm install --g lerna


# restclient install

if [ ! -d $HOME/restclient-cpp/ ]; then
    git clone https://github.com/mrtazz/restclient-cpp.git
fi
cd ~
sudo chown -R $user:$user restclient-cpp/
cd restclient-cpp


sudo ./autogen.sh
sudo ./configure
sudo make install

cd ~
sudo chown -R $user:$user /home/$user/.config
sudo chown -R $user:$user /usr/lib/node_modules


# Node.js libraries
cd ~/blockbench/src/micro
npm install web3
npm install zipfian
npm install bignumber.js
npm install fabric-ca-client
npm install fabric-client
npm install fabric-network
cd ~

cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
#npm install web3
#npm install zipfian
#npm install bignumber.js
npm install fabric-ca-client
npm install fabric-client
npm install fabric-network
cd ~

cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
#npm install web3
#npm install zipfian
#npm install bignumber.js
npm install fabric-ca-client
npm install fabric-client
npm install fabric-network
cd ~

# Install Hyperledger
cd ~/blockbench/benchmark/hyperledger
chmod +x install.sh
./install.sh

cd ~
sudo chmod -R a+rwx ~/blockbench

echo You might need to fix folder permissions:
echo "ls -la ~"
echo "sudo chown -R \$USER:\$USER blockbench/"
echo "sudo chown -R \$USER:\$USER restclient-cpp/"
echo "ls -la ~"


# Make drivers

#cd ~/blockbench/src/macro/kvstore
#make

#cd ~/blockbench/src/macro/smallbank 
#make


