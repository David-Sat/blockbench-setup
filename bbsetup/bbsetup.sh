#!/bin/bash  
cd ~
HDIR=$HOME
user=$(logname)

echo -------clone benchmark-------
# Git clone benchmark
if [ ! -d $HOME/blockbench ]; then
    git clone https://github.com/David-Sat/blockbench.git
fi
cd ~
echo -------blockbench folder permissions-------
chmod 755 ~/blockbench
sudo chown -R $user ~/.config
#sudo chown -R $user:$user blockbench/

echo -------install c++ libraries-------
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


echo -------clone restclient-------
# restclient install
if [ ! -d $HOME/restclient-cpp/ ]; then
    git clone https://github.com/mrtazz/restclient-cpp.git
fi
cd ~
#sudo chown -R $user:$user restclient-cpp/
chmod 755 ~/restclient-cpp
cd restclient-cpp

echo -------restclient make install-------
./autogen.sh
./configure
sudo make install

cd ~
#sudo chown -R $user:$user /home/$user/.config
#sudo chown -R $user:$user /usr/lib/node_modules

echo -------micro npm installs-------
# Node.js libraries
cd ~/blockbench/src/micro
npm install web3
npm install zipfian
npm install bignumber.js
#npm install fabric-ca-client
#npm install fabric-client
#npm install fabric-network

npm install
cd ~

echo -------macro npm installs-------
cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
npm install fabric-ca-client
npm install fabric-client
npm install 
# -- audit
#cd ~

#cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
#npm install fabric-ca-client
#npm install fabric-client
#cd ~

cd ~
#sudo chmod -R a+rwx ~/blockbench

echo -------hyperledger install-------
# Install Hyperledger
cd ~/blockbench/benchmark/hyperledger
chmod +x install.sh
sudo ./install.sh

echo -------make drivers-------
# Make drivers
cd ~/blockbench/src/macro/kvstore
make

cd ~/blockbench/src/macro/smallbank 
make

echo 
echo "You might need to fix folder permissions:"
echo
echo "ls -la ~"
echo "sudo chown -R \$USER:\$USER blockbench/"
echo "sudo chown -R \$USER:\$USER restclient-cpp/"
echo "sudo chown -R \$USER:\$USER ~/.config"
echo "ls -la ~"







