#!/bin/bash


helpFunction()
{
    echo ""
    echo -e "./txrange.sh -b ycsb -T 4 -o 01 -s 300 -w workloada.spec"
    echo -e "./txrange.sh -b donothing -T 4 -o 01 -s 300"
    echo -e "./txrange.sh -b smallbank -T 4 -o 01 -n 1000 -f stat.txt -O -s 300"
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




interval=100
i=100
end=500

while [ $i -le $end ]; do
    if [ "$i" -lt "100" ]; then
        txr_out="0""$i"
    else
        txr_out="$i"
    fi
    ./solofabric.sh -b $benchmark -t $i -T $threads -o "$output_name"_"$txr_out" -s $stimeout -w $workload -n $ops -f $fp
    i=$(($i+$interval))
done 