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
    echo -e "./multibenchmark.sh -b ycsb -t 100 -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300"
    echo -e "./multibenchmark.sh -b donothing -t 100 -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300"
    echo -e "./multibenchmark.sh -b smallbank -t 100 -T 4 -o 01 -n 1000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300"
    exit 1 # Exit script after printing help
}



while getopts "b:w:t:T:o:n:f:s:O:P:" opt
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
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done


# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] || [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$ordereraddr" ] || [ -z "$peeraddr" ] || [ -z "$stimeout" ]
then
    echo "Some important parameters are empty";
    helpFunction
fi



workloads=`ls $workload_dir/*.spec`

case $benchmark in
    kvstore|ycsb|donothing)
        for wl in $workloads
        do
            wl_name_ext="${wl##*/}"
            wl_name="${wl_name_ext%.spec}"
            output_dir="$script_directory"/results/"$output_name"_"$benchmark"_"$wl_name".result
            ./solobenchmark.sh -b $benchmark -t $txrate -T $threads -o $output_dir -w workloads/$wl_name_ext -O $ordereraddr -P $peeraddr -s $stimeout
        done
        ;;
    smallbank)
        output_dir="$script_directory"/results/"$output_name"_"$benchmark".result
        ./solobenchmark.sh -b $benchmark -t $txrate -T $threads -o $output_dir -n $ops -f $fp -O $ordereraddr -P $peeraddr -s $stimeout
        ;;
    *)
        echo "Sorry, I cannot yet recognize this benchmark"
        ;;




