#!/bin/bash


helpFunction()
{
    echo ""
    echo -e "./txrange.sh -b ycsb -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec -l 70 -u 160 -i 20"
    echo -e "./txrange.sh -b donothing -T 16 -o 01 -O localhost:7041 -P localhost:7051 -s 300 -l 70 -u 160 -i 20"
    echo -e "./txrange.sh -b smallbank -T 4 -o 01 -n 1000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300 -l 70 -u 160 -i 20"
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

configpath="$HOME/blockbench/benchmark/fabric-v2.2/configtx/configtx.yaml"

msgcount=(50 100 200 300)

for index in ${!msgcount[@]}; do
    sed -i -E "235s/[0-9]+/${index}/" $configpath

    if [ "$index" -lt "100" ]; then
        msg_out="0""$index"
    else
        msg_out="$index"
    fi

    echo ""
    echo "Executing solofabric.sh with txrate: $index"
    echo ""
    ./txrange.sh -b $benchmark -t $index -T $threads -o "$output_name/$msg_out" -s $stimeout -w $workload -n $ops -f $fp
    
    
done