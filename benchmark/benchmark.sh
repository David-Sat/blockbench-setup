#!/bin/bash


helpFunction()
{
    echo ""
    echo "Usage: $0 -b <benchmark> -w <workload> -x <txrate> -t <threads>"
    echo -e "\t-b Description of benchmark"
    echo -e "\t-w Description of workload"
    echo -e "\t-x Description of txrate"
    echo -e "\t-t Description of threads"
    exit 1 # Exit script after printing help
}

while getopts "b:w:x:t:" opt
do
    case "$opt" in
        b ) benchmark="$OPTARG" ;;
        w ) workload="$OPTARG" ;;
        x ) txrate="$OPTARG" ;;
        t ) threads="$OPTARG" ;;
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
echo "$benchmark"
echo "$workload"
echo "$txrate"
echo "$threads"

case $benchmark in
    kvstore)
        echo "kvstore"
        kvstoreFunction
        ;;
    donothing)
        echo "donothing"
        ;;
    smallbank)
        echo "smallbank"
        ;;
    cpuheavy)
        echo "cpuheavy"
        ;;
    ioheavy)
        echo "ioheavy"
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac

echo "Yup"

startNetwork()
{
    echo "Spinning up four-nodes Fabric Network"
    cd ~/blockbench/benchmark/fabric-v1.4/four-nodes-docker
    docker-compose -f docker-compose.yaml up -d
    echo "Create and join channel for each peer"
    ./setup.sh
}

configureWorkload()
{
    echo "Configuring workload"
    case $benchmark in
    kvstore)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_kv.sh
        ;;
    donothing)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_donothing.sh
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
        npm install
        ./deploy.sh
        ;;
    cpuheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/cpuheavy/fabric-v1.4


        ;;
    ioheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/ioheavy/fabric-v1.4
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac

}


kvstoreFunction()
{
    echo ""
    startNetwork

}