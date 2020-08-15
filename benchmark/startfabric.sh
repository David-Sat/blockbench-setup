#!/bin/bash

CHANNEL_NAME=mychannel
endpoint=localhost:8800,localhost:8801,localhost:8802

script_directory=$HOME/blockbench-setup/benchmark


helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -t <txrate> -T <threads> -o <output_name>"
    echo -e "\t-b [ycsb, donothing, smallbank] (*)"
    echo -e "\t-t The txrate (*)"
    echo -e "\t-T The number of threads (*)"
    echo -e "\t-s time out in seconds (all)"
    echo "Usage: "
    echo -e "./startfabric.sh -b ycsb -t 40 -T 4 -o 01  -w workloada.spec"
    echo -e "./startfabric.sh -b donothing -t 40 -T 4 -o 01 -w workloada.spec"
    echo -e "./startfabric.sh -b smallbank -t 40 -T 4 -o 01 -n 1000 -f stat.txt"
    exit 1 # Exit script after printing help
}

startNetwork()
{
    echo "Launch and setup"
    cd ~/blockbench/benchmark/fabric-v2.2
    ./network.sh up createChannel -ca -i 2.2 -c ${CHANNEL_NAME}
    sleep 5

    echo "Deploy Chaincode"
    CC_SRC_PATH="../contracts/fabric-v2.2/${CC_NAME}"
    ./network.sh deployCC -ccn ${CC_NAME} -ccp ${CC_SRC_PATH}
    sleep 5

    echo "Install dependencies and prepare identities"
    cd services/;
    npm install;
    node enrollAdmin.js
    node registerUser.js

    echo "Launch processes"
    node block-server.js ${CHANNEL_NAME} 8800 > block-server.log 2>&1 &

    node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8801 > txn-server-8801.log 2>&1 &
    node txn-server.js ${CHANNEL_NAME} ${CC_NAME} ${MODE} 8802 > txn-server-8802.log 2>&1 &
}


ycsbplusFunction(){
    if [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$workload" ]
    then
        echo "Some important parameters are empty";
        helpFunction
    fi

    wl_name="${workload%.spec}"  #"workloada"
    output_dir_tmp="$output_name"_"$benchmark"_"$wl_name".txt
    output_dir="$script_directory"/results/$output_dir_tmp

    startNetwork

    cd ~/blockbench/src/macro/kvstore
    echo "execute driver with this:"
    echo "./driver -db fabric-v2.2 -threads $threads -P workloads/$workload -txrate $txrate -endpoint {$endpoint} -wl $benchmark -wt 20"
}


smallbankFunction(){
    if [ -z "$txrate" ] || [ -z "$threads" ] || [ -z "$output_name" ] || [ -z "$ops" ] || [ -z "$fp" ]
    then
        echo "Some important parameters are empty";
        helpFunction
    fi
    
    output_dir_tmp="$output_name"_"$benchmark"_txr"$txrate".txt
    output_dir="$script_directory"/results/$output_dir_tmp

    startNetwork

    cd $script_directory
    echo "execute driver with this:"
    echo "./driver -db fabric-v2.2 -ops $ops -threads $threads -txrate $txrate -fp $fp -endpoint ${endpoint}"
}

ioheavyFunction(){
    #TODO
    echo "Not implemented yet"
}

cpuheavyFunction(){
    #TODO
    echo "Not implemented yet"
}


while getopts "b:w:t:T:o:n:f:w:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        t ) txrate="$OPTARG" ;;
        T ) threads="$OPTARG" ;;
        o ) output_name="$OPTARG" ;; #todo
        n ) ops="$OPTARG" ;;
        f ) fp="$OPTARG" ;;
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
    ycsb|donothing)
        CC_NAME=kvstore
        MODE=open_loop
        ycsbplusFunction
        ;;
    smallbank)
        CC_NAME=smallbank
        MODE=open_loop
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




#cd ~/blockbench/benchmark/fabric-v2.2
#sudo ./network.sh down

#ps aux  |  grep -i block-server  |  awk '{print $2}' | xargs kill -9
#ps aux  |  grep -i txn-server  |  awk '{print $2}' | xargs kill -9

#cd services/
#rm wallet/*


#cd ~/blockbench-setup/benchmark