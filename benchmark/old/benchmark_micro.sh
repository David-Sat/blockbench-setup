configureWorkload()
{
    echo "Configuring workload and deploying chaincode"
    case $benchmark in
    kvstore|ycsb)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_kv.sh
        cd ..
        # temporary solution:
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint $ordereraddr,$peeraddr -wl ycsb |& tee output_kv.txt
        ;;
    donothing)
        cd ~/blockbench/src/macro/kvstore/fabric-v1.4-node
        npm install
        ./deploy_donothing.sh
        cd ..
        # temporary solution:
        ./driver -db fabric-v1.4 -threads $threads -P $workload -txrate $txrate -endpoint localhost:7041,localhost:7051 -wl donothing |& tee output_dn.txt
        ;;
    smallbank)
        cd ~/blockbench/src/macro/smallbank/api_adapters/fabric-v1.4-node
        npm install
        ./deploy.sh
        cd ../..
        # temporary solution:
        ./driver  -db fabric-v1.4 -ops 1000 -threads 4 -txrate $txrate -fp stat.txt -endpoint localhost:7041,localhost:7051 |& tee output_sb.txt
        ;;
    cpuheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/cpuheavy/fabric-v1.4
        # TODO: add ./benchmark.sh <array_size>
        ;;
    ioheavy)
        cd ~/blockbench/src/micro
        npm install
        cd ~/blockbench/src/micro/ioheavy/fabric-v1.4
        # TODO: add write and scan or seperate micro into own script
        ;;
    *)
        echo "Sorry, could not recognize benchmark"
        ;;
esac
}