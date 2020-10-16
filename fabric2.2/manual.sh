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

    mkdir results/smallbank_lv

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b smallbank -t 100 -T 16 -o "smallbank_lv/$i"_"sm_leveldb" -s 300 -n 10000000 -f stat.txt
        i=$(($i+$interval))
    done 
}


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

zipfian_function
ycsb_leveldb_function
