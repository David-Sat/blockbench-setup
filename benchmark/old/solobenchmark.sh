#!/bin/bash

script_directory=$HOME/blockbench-setup/benchmark

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -t <txrate> -T <threads> -o <output_name>"
    echo -e "\t-b [ycsb, donothing, smallbank] (*)"
    echo -e "\t-w [workloads/workloada.spec (...)] (kvstore)"
    echo -e "\t-t The txrate (*)"
    echo -e "\t-T The number of threads (*)"
    echo -e "\t-o The name of the output file (*)"
    echo -e "\t-n number of operations (smallbank)"
    echo -e "\t-f fp (smallbank)"
    echo -e "\t-s time out in seconds (all)"
    echo -e "\t-O Orderer address (*)"
    echo -e "\t-P Peer address (*)"
    echo "Usage: "
    echo -e "./solobenchmark.sh -b ycsb -t 100 -T 16 -o ycsb_example.txt -w workloads/workloada.spec -O localhost:7041 -P localhost:7051 -s 300"
    echo -e "./solobenchmark.sh -b donothing -t 100 -T 16 -o dono_example.txt -w workloads/workloada.spec -O localhost:7041 -P localhost:7051 -s 300"
    echo -e "./solobenchmark.sh -b smallbank -t 100 -T 4 -o dono_example.txt -n 1000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300"
    exit 1 # Exit script after printing help
}

startNetwork()
{
    echo "Spinning up four-nodes Fabric Network"
    cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
    docker-compose -f docker-compose.yaml up -d
    sleep 5
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
        ;;
    donothing)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_donothing.sh
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
        npm install
        ./deploy.sh
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}

while getopts "b:w:t:T:o:n:f:s:O:P:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        o ) output_name="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        O ) ordereraddr="$OPTARG" ;;
        P ) peeraddr="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done


# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] || [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ]
then
    echo "Some important parameters are empty";
    helpFunction
fi

if [ -z "$workload" ]
then 
    workload=null
fi


if [ -z "$ops" ] || [ -z "$fp" ]
then
    ops=null
    fp=null
fi


output_dir="$script_directory"/results/$output_name

# Begin script in case all parameters are correct

startNetwork
configureWorkload

cd $script_directory

if [ -z "$stimeout" ]
then
    ./startdriver.sh -b $benchmark -w $workload -t $txrate -T $threads -n $ops -f $fp -O $ordereraddr -P $peeraddr |& tee $output_dir
else 
    timeout $stimeout ./startdriver.sh -b $benchmark -w $workload -t $txrate -T $threads -n $ops -f $fp -O $ordereraddr -P $peeraddr |& tee $output_dir
fi

cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
docker-compose -f docker-compose.yaml down

