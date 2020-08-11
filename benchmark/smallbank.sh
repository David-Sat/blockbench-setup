#!/bin/bash

script_directory=$HOME/blockbench-setup/benchmark

helpFunction()
{
    echo "The script smallbank.sh can only be executed through the function startbenchmark.sh and not directly. (The network has to be started first)"

    exit 1 # Exit script after printing help
}


while getopts "b:t:T:s:n:f:O:P:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        O ) ordereraddr="$OPTARG" ;;
        P ) peeraddr="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done


# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] || [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ] || [ -z "$fp" ] || [ -z "$ops" ]
then
    echo "Some important parameters are empty";
    helpFunction
fi


# Begin script in case all parameters are correct


echo "Configuring workload and deploying chaincode"
cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
npm install
./deploy.sh


echo benchmark=$benchmark
echo txrate=$txrate
echo threads=$threads
echo ordereraddress=$ordereraddr
echo peeraddress=$peeraddr
echo stimeout=$stimeout
echo fp=$fp
echo ops=$ops
echo


cd $script_directory

if [ -z "$stimeout" ]
then
    cd ~/blockbench/src/macro/smallbank
    ./driver -db fabric-v1.4 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint $ordereraddr,$peeraddr
else
    cd ~/blockbench/src/macro/smallbank
    timeout $stimeout ./driver -db fabric-v1.4 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint $ordereraddr,$peeraddr
fi



