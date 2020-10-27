#!/bin/bash


helpFunction()
{
    echo ""
    echo -e "./workloads.sh -b ycsb -T 8 -t 100 -o 01 -s 300"
    echo -e "./workloads.sh -b donothing -T 8 -t 100 -o 01 -s 300"
    exit 1 # Exit script after printing help
}

commentFunction()
{
    echo
echo "Benchmarking with couchdb from now on"
echo
    for index in ${workload_names[@]}; do
    workload="$index"".spec"


    echo ""
    echo "Executing workloads.sh with workload: $workload"
    echo ""
    ./solofabric.sh -b $benchmark -T $threads -t $txrate -o "$output_name/$workload"_"couchdb" -s $stimeout -w $workload -d couchdb

    done
}

while getopts "b:T:t:o:n:f:s:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        o ) output_name="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

if [ -z "$benchmark" ]
then
    echo "The benchmark parameter -b is empty";
    helpFunction
fi

mkdir results/$output_name

#workload_names=(0 1 2 3 4 5 6 7 8 9 10)

#workload_names=(a b c d e f g h i j k)
workload_names=(a b c)
#workload_names=(f f f f f)
i=0
#workload_names=(8 9 10)

echo
echo "Starting benchmark with goleveldb"
echo

for index in ${workload_names[@]}; do
    workload="dist_""$index"".spec"
    wlname="dist_""$index"
    

    echo ""
    echo "Executing workloads.sh with workload: $workload"
    echo ""
    ./solofabric.sh -b $benchmark -T $threads -t $txrate -o "$output_name/$wlname"_"$i" -s $stimeout -w $workload
    i=$((i+1))
    
done



