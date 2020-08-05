#!/bin/bash

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -w <workload> -t <txrate> -T <threads>"
    echo -e "\t-b [ycsb, donothing, smallbank] (*)"
    echo -e "\t-w [workloads/workloada.spec (...)] (kvstore)"
    echo -e "\t-t The txrate (*)"
    echo -e "\t-T The number of threads (*)"
    echo -e "\t-n number of operations (smallbank)"
    echo -e "\t-f fp (smallbank)"
    echo -e "\t-O Orderer address (*)"
    echo -e "\t-P Peer address (*)"
    exit 1 # Exit script after printing help
}

startBenchmark()
{
    echo "Configuring workload and deploying chaincode"
    case $benchmark in
    ycsb|donothing)
        cd ~/blockbench/src/macro/kvstore
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl $benchmark
        ;;
    
    smallbank)
        cd ~/blockbench/src/macro/smallbank
        ./driver -db fabric-v1.4 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint $ordereraddr,$peeraddr
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}


while getopts "b:w:t:T:o:n:f:O:P:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        O ) ordereraddr="$OPTARG" ;;
        P ) peeraddr="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

echo !benchmark=$benchmark
echo workload=$workload
echo !txrate=$txrate
echo !threads=$threads
echo operations=$ops
echo fp=$fp
echo !ordereraddress=$ordereraddr
echo !peeraddress=$peeraddr
echo

# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] || [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ]
then
    echo "Some important parameters are empty";
    helpFunction
fi

echo benchmark=$benchmark
echo workload=$workload
echo txrate=$txrate
echo threads=$threads
echo operations=$ops
echo fp=$fp
echo ordereraddress=$ordereraddr
echo peeraddress=$peeraddr
echo

startBenchmark
