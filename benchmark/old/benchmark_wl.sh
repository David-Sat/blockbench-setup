#!/bin/bash

ordereraddr="localhost:7041"
peeraddr="localhost:7051"
txrate="100"
threads="16"
out_num="00"

helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -x <txrate> -t <threads> -o <out_num>"
    echo -e "\t-b [kvstore, donothing, smallbank] (*)"
    echo -e "\t-x The txrate"
    echo -e "\t-t The number of threads"
    echo -e "\t-t identifier for outputs (for example: 01)"
    echo -e "\tExample:"
    echo -e "\t./benchmark.sh -b kvstore"
    exit 1 # Exit script after printing help
}

executeBenchmarks(){
    curr_workload=$1

    echo "Executing benchmark for $curr_workload"
    ./benchmark -b $benchmark -x $txrate -t $threads -o $out_num"" -w "workloads/"$curr_workload -s 300

    ./shutdown.sh
}


while getopts "b:x:t:o:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        x ) txrate="$OPTARG" ;;
        t ) threads="$OPTARG" ;;
        o ) out_num="$OPTARG" ;;
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
echo "txrate : $txrate"
echo "threads: $threads"


executeBenchmarks workloada.spec
executeBenchmarks workloada.spec
executeBenchmarks workloada.spec
executeBenchmarks workloada.spec




# set timeframe and execute ./shutdown.sh