# Running BlockBench Benchmark
## Start four-nodes-docker Fabric network
 - Open four-nodes-docker directory
 - Spin up a Fabric network with a single orderer and four peers under the same organization
 - Run the network in the docker environment of the localhost in the same bridge network

```
cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
docker-compose -f docker-compose.yaml up -d
./setup.sh 		# create the channel and join the channel for each peer
```
## Configure Workload
Enter the corresponding workload directory  ([in more Detail here](https://github.com/ooibc88/blockbench/tree/master/src/macro)).
```
cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node		  # for kvstore (ymcb and donothing)
cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node # for smallbank
cd ~/blockbench/src/micro					  # for micro
npm install
```
## Deploy Chaincode
[Deploy the chaincode](https://github.com/ooibc88/blockbench/tree/master/src/macro)  via the bash script.
#### KVStore:
```
#Assume under src/macro/kvstore/fabric-v1.4-node
./deploy_kv.sh
```
#### DoNothing:
```
#Assume under src/macro/kvstore/fabric-v1.4-node
./deploy_donothing.sh
```
#### Smallbank:
```
#Assume under src/macro/smallbank/api_adapters/fabric-v1.4-node
./deploy.sh
```
## Run Benchmark
### Macro 
#### KVStore
Usage example:
```
./driver -db fabric-v1.4 -threads 16 -P workloads/workloada.spec -txrate 100 -endpoint <orderer_addr>,<peer_addr> -wl ycsb
```
Run on localhost:
```
./driver -db fabric-v1.4 -threads 16 -P workloads/workloada.spec -txrate 100 -endpoint localhost:7041,localhost:7051 -wl ycsb
```
#### DoNothing
Usage example:
```
./driver -db fabric-v1.4 -threads 16 -P workloads/workloada.spec -txrate 100 -endpoint <orderer_addr>,<peer_addr> -wl donothing
```
Run on localhost:
```
./driver -db fabric-v1.4 -threads 16 -P workloads/workloada.spec -txrate 100 -endpoint localhost:7041,localhost:7051 -wl donothing
```
#### Smallbank
Usage example:
```
./driver  -db fabric-v1.4 -ops 1000 -threads 4 -txrate 100 -fp stat.txt -endpoint <orderer_addr>,<peer_addr>
```
Run on localhost:
```
./driver  -db fabric-v1.4 -ops 1000 -threads 4 -txrate 100 -fp stat.txt -endpoint localhost:7041,localhost:7051

```
### Micro
```
//TODO
```
## Shut down
```
cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
docker-compose -f docker-compose.yaml down
```

