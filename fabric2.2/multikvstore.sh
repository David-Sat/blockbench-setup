#!/bin/bash

CHANNEL_NAME=mychannel
endpoint=localhost:8800,localhost:8801,localhost:8802

script_directory=$HOME/blockbench-setup/fabric2.2
workload_dir=$HOME/blockbench/src/macro/kvstore/workloads


helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -t <txrate> -T <threads> -o <output_name>"
    echo -e "\t-b [ycsb, donothing, smallbank] (*)"
    echo -e "\t-t The txrate (*)"
    echo -e "\t-T The number of threads (*)"
    echo -e "\t-s time out in seconds (all)"
    echo "Usage: "
    echo -e "./kvstore2.sh -b ycsb -t 40 -T 4 -o 01 -s 40"
    echo -e "./kvstore2.sh -b donothing -t 40 -T 4 -o 01 -s 40"
    exit 1 # Exit script after printing help
}

startNetwork()
{
    echo "Launch and setup"
    cd ~/blockbench/benchmark/fabric-v2.2
    ./network.sh up createChannel -ca -i 2.2 -c ${CHANNEL_NAME}
    sleep 5

    echo "Deploy Chaincode"
    CC_SRC_PATH="../contracts/fabric-v2.2/${CC_NAME}"
    ./network.sh deployCC -ccn ${CC_NAME} -ccp ${CC_SRC_PATH}
    sleep 5

    echo "Install dependencies and prepare identities"
    cd services/;
    npm install;
    node enrollAdmin.js
    node registerUser.js
    sleep 1

    echo "Launch processes"
    node block-server.js ${CHANNEL_NAME} 8800 > block-server.log 2>&1 &
    sleep 1

    node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8801 > txn-server-8801.log 2>&1 &
    sleep 1
    node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8802 > txn-server-8802.log 2>&1 &
    sleep 1
}



while getopts "b:w:t:T:s:o:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        o ) output_name="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

if [ -z "$benchmark" ]
then
    echo "The benchmark parameter -b is empty";
    helpFunction
fi




CC_NAME=kvstore
MODE=open_loop
workloads=`ls $workload_dir/*.spec`

if [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] 
then
    echo "Some important parameters are empty";
    helpFunction
fi

startNetwork
sleep 1

for wl in $workloads
do
    wl_name_ext="${wl##*/}"
    wl_name="${wl_name_ext%.spec}"
    output_dir="$script_directory"/results/"$output_name"_"$benchmark"_"$wl_name".txt

    cd $script_directory
    ./macrodriver.sh -b $benchmark -t $txrate -T $threads -s $stimeout -w $wl_name_ext -e $endpoint |& tee $output_dir
done


cd $script_directory
./fabricdown.sh
