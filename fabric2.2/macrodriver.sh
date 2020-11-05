#!/bin/bash

script_directory=$HOME/blockbench-setup/fabric2.2

helpFunction()
{
    echo "The script macrodriver.sh can only be executed through the function startbenchmark.sh and not directly. (The network has to be started first)"

    exit 1 # Exit script after printing help
}



while getopts "b:w:t:T:s:n:f:w:e:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        s ) stimeout="$OPTARG" ;;
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        e ) endpoint="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$benchmark" ] 
then
    echo "Some important parameters are empty";
    helpFunction
fi


echo benchmark=$benchmark
echo txrate=$txrate
echo threads=$threads
echo endpoint=$endpoint
echo zipfian_const=unknown

if [ -z "$stimeout" ]
then
    echo timeout=0
else
    echo stimeout=$stimeout    
fi

if [ -z "$workload" ]
then
    echo workload="none"
else
    echo workload=$workload    
fi
echo



case $benchmark in
    ycsb|donothing)
        cd ~/blockbench/src/macro/kvstore
        if [ -z "$stimeout" ]
        then
            ./driver -db fabric-v1.4 -threads $threads -P workloads/$workload -txrate $txrate -endpoint ${endpoint} -wl $benchmark -wt 20
        else
            timeout $stimeout ./driver -db fabric-v1.4 -threads $threads -P workloads/$workload -txrate $txrate -endpoint ${endpoint} -wl $benchmark -wt 20
        fi
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank
        if [ -z "$stimeout" ]
        then
            ./driver -db fabric-v1.4 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint ${endpoint} -wt 20
        else
            timeout $stimeout ./driver -db fabric-v1.4 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint ${endpoint} -wt 20
        fi
        ;;
    *)
        echo "Sorry, I cannot recognize this benchmark"
        ;;
esac


