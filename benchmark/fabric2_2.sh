#!/bin/bash

CHANNEL_NAME=mychannel

CC_NAME=kvstore
MODE=open_loop
endpoint=localhost:8800,localhost:8801,localhost:8802


echo "Launch and setup"
cd ~/blockbench/benchmark/fabric-v2.2
./network.sh up createChannel -ca -i 2.2 -c ${CHANNEL_NAME}


echo "Deploy Chaincode"
CC_SRC_PATH="../contracts/fabric-v2.2/${CC_NAME}"
./network.sh deployCC -ccn ${CC_NAME} -ccp ${CC_SRC_PATH}


echo "Install dependencies and prepare identities"
cd services/;
npm install;
node enrollAdmin.js
node registerUser.js


echo "Launch processes"
node block-server.js ${CHANNEL_NAME} 8800 > block-server.log 2>&1 &

node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8801 > txn-server-8801.log 2>&1 &
node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8802 > txn-server-8802.log 2>&1 &




#cd ~/blockbench/src/macro/kvstore
#endpoint=localhost:8800,localhost:8801,localhost:8802
#./driver -db fabric-v2.2 -threads 1 -P workloads/workloada.spec -txrate 5 -endpoint $endpoint -wl ycsb -wt 20

#cd ~/blockbench/benchmark/fabric-v2.2

#sudo ./network.sh down

#ps aux  |  grep -i block-server  |  awk '{print $2}' | xargs kill -9
#ps aux  |  grep -i txn-server  |  awk '{print $2}' | xargs kill -9

#cd services/
#rm wallet/*
