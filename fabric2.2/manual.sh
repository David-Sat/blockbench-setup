#!/bin/bash


ycsb_leveldb_function()
{   
    interval=1
    i=1
    end=5

    mkdir results/sm_workload

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "sm_workload/$i"_"sm_workload" -s 300 -w sm_workload.spec
        i=$(($i+$interval))
    done 
}

donothing_function()
{   
    interval=1
    i=1
    end=5

    mkdir results/donothing

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "sm_workload/$i"_"sm_workload" -s 300 -w sm_workload.spec
        i=$(($i+$interval))
    done 
}



ycsb_couchdb_function()
{
    interval=1
    i=1
    end=5

    mkdir results/couchdb2

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "couchdb2/$i"_"couchdb2" -s 300 -w rw_d.spec -d couchdb
        i=$(($i+$interval))
    done 
}

smallbank_couchdb_function()
{
    interval=1
    i=1
    end=5

    mkdir results/smallbank_cb

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b smallbank -t 100 -T 16 -o "smallbank_cb/$i"_"sm_couchdb" -s 300 -n 10000000 -f stat.txt  -d couchdb
        i=$(($i+$interval))
    done 
}

smallbank_leveldb_function()
{
    interval=1
    i=1
    end=5

    mkdir results/smallbank_comp

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b smallbank -t 100 -T 16 -o "smallbank_comp/$i"_"sb_comp" -s 300 -n 10000000 -f stat.txt
        i=$(($i+$interval))
    done 
}

smallbank_function()
{
    mkdir results/smallbank_recordcount
    smallbankpath="$HOME/blockbench/src/macro/smallbank/smallbank.cc"

    recordcount=(200 400 600 800 1000 1200 1400 1600 1800 2000)

    for index in ${recordcount[@]}; do
        sed -i -E "44s/[0-9]+/${index}/" $smallbankpath

        cd $HOME/blockbench/src/macro/smallbank
        make clean
        make
        cd $HOME/blockbench-setup/fabric2.2

        if [ "$index" -lt "1000" ]; then
            rcc_out="0""$index"
        else
            rcc_out="$index"
        fi


        interval=1
        i=1
        end=5

        while [ $i -le $end ]; do
            ./solofabric.sh -b smallbank -t 100 -T 16 -o "smallbank_recordcount/$rcc_out"_"$i"_"sb_rcc" -s 300 -n 10000000 -f stat.txt
            i=$(($i+$interval))
        done 
    done
}

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

sed -i -E "235s/[0-9]+/200/" $configpath



zipfian_function()
{
    interval=1
    i=1
    end=5


    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi

        

        ./zipfian.sh -b ycsb -t 100 -T 16 -o "zipfian_$i" -s 300 -w rw_d.spec
        i=$(($i+$interval))
    done 
}



#ycsb_leveldb_function
#ycsb_couchdb_function

#smallbank_couchdb_function
#smallbank_leveldb_function

#zipfian_function
#smallbank_leveldb_function

#./workloads.sh -b ycsb -T 16 -t 100 -o rc1 -s 300
#./workloads.sh -b ycsb -T 16 -t 100 -o rc2 -s 300
#./workloads.sh -b ycsb -T 16 -t 100 -o rc3 -s 300
#./workloads.sh -b ycsb -T 16 -t 100 -o rc4 -s 300
#./workloads.sh -b ycsb -T 16 -t 100 -o rc5 -s 300

# ./workloads.sh -b ycsb -T 16 -t 100 -o dist1 -s 300
# ./workloads.sh -b ycsb -T 16 -t 100 -o dist2 -s 300
# ./workloads.sh -b ycsb -T 16 -t 100 -o dist3 -s 300
# ./workloads.sh -b ycsb -T 16 -t 100 -o dist4 -s 300
# ./workloads.sh -b ycsb -T 16 -t 100 -o dist5 -s 300


# ./msgrange.sh -b ycsb -T 16 -o msgrange_ycsb1 -s 300 -w workloada.spec
# ./msgrange.sh -b ycsb -T 16 -o msgrange_ycsb2 -s 300 -w workloada.spec
# ./msgrange.sh -b ycsb -T 16 -o msgrange_ycsb3 -s 300 -w workloada.spec
# ./msgrange.sh -b ycsb -T 16 -o msgrange_ycsb4 -s 300 -w workloada.spec
# ./msgrange.sh -b ycsb -T 16 -o msgrange_ycsb5 -s 300 -w workloada.spec

# ./msgrange.sh -b smallbank -T 16 -o msgrange_smallbank1 -s 300 -w workloada.spec
# ./msgrange.sh -b smallbank -T 16 -o msgrange_smallbank2 -s 300 -w workloada.spec
# ./msgrange.sh -b smallbank -T 16 -o msgrange_smallbank3 -s 300 -w workloada.spec
# ./msgrange.sh -b smallbank -T 16 -o msgrange_smallbank4 -s 300 -w workloada.spec
# ./msgrange.sh -b smallbank -T 16 -o msgrange_smallbank5 -s 300 -w workloada.spec

./msgrange.sh -b donothing -T 16 -o msgrange_donothing1 -s 300 -w rw_k.spec
./msgrange.sh -b donothing -T 16 -o msgrange_donothing2 -s 300 -w rw_k.spec
./msgrange.sh -b donothing -T 16 -o msgrange_donothing3 -s 300 -w rw_k.spec
./msgrange.sh -b donothing -T 16 -o msgrange_donothing4 -s 300 -w rw_k.spec
./msgrange.sh -b donothing -T 16 -o msgrange_donothing5 -s 300 -w rw_k.spec


# smallbank_function

# smallbankpath="$HOME/blockbench/src/macro/smallbank/smallbank.cc"

# sed -i -E "44s/[0-9]+/1000/" $smallbankpath

# cd $HOME/blockbench/src/macro/smallbank
# make clean
# make
# cd $HOME/blockbench-setup/fabric2.2


./workloads.sh -b donothing -T 16 -t 100 -o rcdn1 -s 300
./workloads.sh -b donothing -T 16 -t 100 -o rcdn2 -s 300
./workloads.sh -b donothing -T 16 -t 100 -o rcdn3 -s 300
./workloads.sh -b donothing -T 16 -t 100 -o rcdn4 -s 300
./workloads.sh -b donothing -T 16 -t 100 -o rcdn5 -s 300


