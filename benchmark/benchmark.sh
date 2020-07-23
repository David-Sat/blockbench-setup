#!/bin/bash

ordereraddr="localhost:7041"
peeraddr="localhost:7051"
workload="workloads/workloada.spec"
txrate="100"
threads="16"

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -w <workload> -x <txrate> -t <threads>"
    echo -e "\t-b Description of benchmark (*)"
    echo -e "\t-w Description of workload"
    echo -e "\t-x Description of txrate"
    echo -e "\t-t Description of threads"
    echo -e "\tExample:"
    echo -e "\t./benchmark.sh -b kvstore"
    exit 1 # Exit script after printing help
}

startNetwork()
{
    echo "Spinning up four-nodes Fabric Network"
    cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
    docker-compose -f docker-compose.yaml up -d
    echo "Create and join channel for each peer"
    ./setup.sh
}

configureWorkload()
{
    echo "Configuring workload and deploying chaincode"
    case $benchmark in
    kvstore|ycsb)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_kv.sh
        cd ..
        # temporary solution:
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl ycsb |& tee output_kv.txt
        ;;
    donothing)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_donothing.sh
        cd ..
        # temporary solution:
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint localhost:7041,localhost:7051 -wl donothing |& tee output_dn.txt
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
        npm install
        ./deploy.sh
        cd ../..
        # temporary solution:
        ./driver  -db fabric-v1.4 -ops 1000 -threads 4 -txrate $txrate -fp stat.txt -endpoint localhost:7041,localhost:7051 |& tee output_sb.txt
        ;;
    cpuheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/cpuheavy/fabric-v1.4
        # TODO: add ./benchmark.sh <array_size>
        ;;
    ioheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/ioheavy/fabric-v1.4
        # TODO: add write and scan or seperate micro into own script
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}

while getopts "b:w:x:t:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        x ) txrate="$OPTARG" ;;
        t ) threads="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ]
then
    echo "The parameter -b is empty";
    helpFunction
fi


# Begin script in case all parameters are correct
echo "benchmark: $benchmark"
echo "workload: $workload"
echo "txrate : $txrate"
echo "threads: $threads"

startNetwork
configureWorkload


# set timeframe and execute ./shutdown.sh