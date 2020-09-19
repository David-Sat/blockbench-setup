#!/bin/bash


helpFunction()
{
    echo ""
    echo -e "./msgrange.sh -b ycsb -T 4 -o 01 -s 300 -w workloada.spec"
    echo -e "./msgrange.sh -b donothing -T 4 -o 01 -s 300"
    echo -e "./msgrange.sh -b smallbank -T 4 -o 01 -n 1000 -f stat.txt -s 300"
    exit 1 # Exit script after printing help
}


while getopts "b:T:o:n:f:s:w:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        o ) output_name="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

if [ -z "$benchmark" ]
then
    echo "The benchmark parameter -b is empty";
    helpFunction
fi

if [ -z "$fp" ]
then
    fp="none"
    ops="none"
fi

if [ -z "$workload" ]
then
    workload="none"
fi

configpath="$HOME/blockbench/benchmark/fabric-v2.2/configtx/configtx.yaml"

msgcount=(50 100 200 300)

for index in ${msgcount[@]}; do
    sed -i -E "235s/[0-9]+/${index}/" $configpath

    if [ "$index" -lt "100" ]; then
        msg_out="0""$index"
    else
        msg_out="$index"
    fi

    echo ""
    echo "Executing txrange.sh with message count: $index"
    echo ""
    ./txrange.sh -b $benchmark -T $threads -o "$output_name/$msg_out" -s $stimeout -w $workload -n $ops -f $fp
    
    
done

sed -i -E "235s/[0-9]+/100/" $configpath