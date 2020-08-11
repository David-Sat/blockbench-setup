#!/bin/bash

script_directory=$HOME/blockbench-setup/benchmark
workload_dir=$HOME/blockbench/src/macro/kvstore/workloads

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -t <txrate> -T <threads> -o <output_name>"
    echo -e "\t-b [ycsb, donothing, smallbank] (*)"
    echo -e "\t-t The txrate (*)"
    echo -e "\t-T The number of threads (*)"
    echo -e "\t-s time out in seconds (all)"
    echo -e "\t-O Orderer address (*)"
    echo -e "\t-P Peer address (*)"
    echo "Usage: "
    echo -e "./startbenchmark.sh -b ycsb -t 100 -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec"
    echo -e "./startbenchmark.sh -b donothing -t 100 -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300"
    echo -e "./startbenchmark.sh -b smallbank -t 100 -T 4 -o 01 -n 1000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300"
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


ycsbplusFunction(){
    if [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ] || [ -z "$workload" ]
    then
        echo "Some important parameters are empty";
        helpFunction
    fi

    wl_name="${workload%.spec}"  #"workloada"
    output_dir_tmp="$output_name"_"$benchmark"_"$wl_name".txt
    output_dir="$script_directory"/results/$output_dir_tmp

    startNetwork

    cd $script_directory
    ./ycsbplus.sh -b $benchmark -w $workload -t $txrate -T $threads -O $ordereraddr -P $peeraddr -s $stimeout |& tee $output_dir
}

smallbankFunction(){
    if [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ] || [ -z "$ops" ] || [ -z "$fp" ]
    then
        echo "Some important parameters are empty";
        helpFunction
    fi
    
    output_dir_tmp="$output_name"_"$benchmark"_txr"$txrate".txt
    output_dir="$script_directory"/results/$output_dir_tmp

    startNetwork

    cd $script_directory
    ./smallbank.sh -b $benchmark -t $txrate -T $threads -n $ops -f $fp -O $ordereraddr -P $peeraddr -s $stimeout |& tee $output_dir
}

ioheavyFunction(){
    #TODO
    echo "Not implemented yet"
}

cpuheavyFunction(){
    #TODO
    echo "Not implemented yet"
}


while getopts "b:w:t:T:o:n:f:s:O:P:w:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        o ) output_name="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        O ) ordereraddr="$OPTARG" ;;
        P ) peeraddr="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

if [ -z "$benchmark" ]
then
    echo "The benchmark parameter -b is empty";
    helpFunction
fi

case $benchmark in
    kvstore|ycsb|donothing)
        ycsbplusFunction
        ;;
    smallbank)
        smallbankFunction
        ;;
    ioheavy)
        ioheavyFunction
        ;;
    cpuheavy)
        cpuheavyFunction
        ;;
    *)
        echo "Sorry, I cannot recognize this benchmark"
        ;;
esac


cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
docker-compose -f docker-compose.yaml down


exit

#rest should be deleted later

workloads=`ls $workload_dir/*.spec`

case $benchmark in
    kvstore|ycsb|donothing)
        for wl in $workloads
        do
            wl_name_ext="${wl##*/}"
            wl_name="${wl_name_ext%.spec}"
            output_dir="$output_name"_"$benchmark"_"$wl_name".txt
            ./solobenchmark.sh -b $benchmark -t $txrate -T $threads -o $output_dir -w workloads/$wl_name_ext -O $ordereraddr -P $peeraddr -s $stimeout
        done
        ;;
    smallbank)
        output_dir="$output_name"_"$benchmark".txt
        ./solobenchmark.sh -b $benchmark -t $txrate -T $threads -o $output_dir -n $ops -f $fp -O $ordereraddr -P $peeraddr -s $stimeout
        ;;
    *)
        echo "Sorry, I cannot yet recognize this benchmark"
        ;;
esac