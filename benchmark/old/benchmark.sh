#!/bin/bash

ordereraddr="localhost:7041"
peeraddr="localhost:7051"
workload="workloads/workloada.spec"
txrate="100"
threads="16"

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -w <workload> -x <txrate> -t <threads> -o <output_name> -s <timeout>"
    echo -e "\t-b [kvstore, donothing, smallbank] (*)"
    echo -e "\t-w [workloads/workloada.spec (...)] *kvstore*"
    echo -e "\t-x The txrate"
    echo -e "\t-t The number of threads"
    echo -e "\t-o The name of the output file"
    echo -e "\t-s The time to run the benchmark"
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
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl ycsb |& tee $output_name
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
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}

configureWorkloadTimeout()
{
    echo "Configuring workload and deploying chaincode"
    case $benchmark in
    kvstore|ycsb)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_kv.sh
        cd ..
        # temporary solution:
        timeout $timeout ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl ycsb |& tee output_kv.txt
        ;;
    donothing)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_donothing.sh
        cd ..
        # temporary solution:
        timeout $timeout ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint localhost:7041,localhost:7051 -wl donothing |& tee output_dn.txt
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
        npm install
        ./deploy.sh
        cd ../..
        # temporary solution:
        timeout $timeout ./driver  -db fabric-v1.4 -ops 1000 -threads 4 -txrate $txrate -fp stat.txt -endpoint localhost:7041,localhost:7051 |& tee output_sb.txt
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}

while getopts "b:w:x:t:o:s:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        x ) txrate="$OPTARG" ;;
        t ) threads="$OPTARG" ;;
        o ) output_file="$OPTARG" ;;
        s ) timeout="$OPTARG" ;;
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