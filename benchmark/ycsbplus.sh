#!/bin/bash

script_directory=$HOME/blockbench-setup/benchmark

helpFunction()
{
    echo "The script ycsbplus.sh can only be executed through the function startbenchmark.sh and not directly. (The network has to be started first)"

    exit 1 # Exit script after printing help
}


while getopts "b:w:t:T:s:O:P:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        O ) ordereraddr="$OPTARG" ;;
        P ) peeraddr="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done


# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] || [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ] || [ -z "$workload" ]
then
    echo "Some important parameters are empty";
    helpFunction
fi


# Begin script in case all parameters are correct


echo "Configuring workload and deploying chaincode"
cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
npm install

case $benchmark in
    ycsb)
        ./deploy_kv.sh
        ;;
    donothing)
        ./deploy_donothing.sh
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac

echo benchmark=$benchmark
echo workload=$workload
echo txrate=$txrate
echo threads=$threads
echo ordereraddress=$ordereraddr
echo peeraddress=$peeraddr
echo stimeout=$stimeout
echo


cd $script_directory

if [ -z "$stimeout" ]
then
    cd ~/blockbench/src/macro/kvstore
    ./driver -db fabric-v1.4 -threads $threads -P workloads/$workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl $benchmark
else
    cd ~/blockbench/src/macro/kvstore
    timeout $stimeout ./driver -db fabric-v1.4 -threads $threads -P workloads/$workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl $benchmark
fi



