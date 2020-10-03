#!/bin/bash


helpFunction()
{
    echo ""
    echo -e "./zipfian.sh -b ycsb -t 100 -T 8 -o 01 -s 300 -w workloada.spec"
    echo -e "./zipfian.sh -b donothing -t 100 -T 8 -o 01 -s 300"
    echo -e "./zipfian.sh -b smallbank -t 100 -T 8 -o 01 -n 1000 -f stat.txt -s 300"
    exit 1 # Exit script after printing help
}


while getopts "b:t:T:o:n:f:s:w:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
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

mkdir results/$output_name


zipfianpath="$HOME/blockbench/src/macro/kvstore/core/zipfian_generator.h"


zipfianconst=(0.0 1.0 2.0)

for index in ${zipfianconst[@]}; do
    sed -i -E "21s/[0-9]+\.[0-9]+/${index}/" $zipfianpath

    cd $HOME/blockbench/src/macro/kvstore
    make clean
    make
    cd $HOME/blockbench-setup/fabric2.2


    zipfian_out="$index"

    echo ""
    echo "Executing solofabric.sh with zipfian constant: $index"
    echo ""
    ./solofabric.sh -b $benchmark -t $txrate -T $threads -o "$output_name/$zipfian_out" -s $stimeout -w $workload -n $ops -f $fp
    
done


sed -i -E "21s/[0-9]+\.[0-9]+/1/" $zipfianpath

cd $HOME/blockbench/src/macro/kvstore
make clean
make
cd $HOME/blockbench-setup/fabric2.2