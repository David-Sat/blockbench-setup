#!/bin/bash  
cd ~
HDIR=$HOME
user=$(logname)

cd $HDIR/blockbench

git pull


echo -------micro npm installs-------
# Node.js libraries
cd $HDIR/blockbench/src/micro
npm install web3
npm install zipfian
npm install bignumber.js
#npm install fabric-ca-client
#npm install fabric-client
#npm install fabric-network

npm install
cd ~

echo -------macro npm installs-------
cd $HDIR/blockbench/src/macro/kvstore/fabric-v1.4-node
npm install fabric-ca-client
npm install fabric-client
npm install 
#cd ~

cd $HDIR/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
npm install

cd ~

#echo -------hyperledger install-------
# Install Hyperledger
#cd ~/blockbench/benchmark/hyperledger
#chmod +x install.sh
#sudo ./install.sh

echo -------make drivers-------
# Make drivers
cd $HDIR/blockbench/src/macro/kvstore
make clean
make

cd $HDIR/blockbench/src/macro/smallbank
make clean
make

cd $HDIR

echo 
echo "You might need to fix folder permissions:"
echo
echo "ls -la ~"
echo "sudo chown -R \$USER:\$USER blockbench/"
echo "sudo chown -R \$USER:\$USER restclient-cpp/"
echo "sudo chown -R \$USER:\$USER ~/.config"
echo "ls -la ~"