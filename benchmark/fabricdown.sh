#!/bin/bash


cd ~/blockbench/benchmark/fabric-v2.2
sudo ./network.sh down

ps aux  |  grep -i block-server  |  awk '{print $2}' | xargs kill -9
ps aux  |  grep -i txn-server  |  awk '{print $2}' | xargs kill -9

cd services/
rm wallet/*


cd ~/blockbench-setup/benchmark