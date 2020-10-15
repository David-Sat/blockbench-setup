#!/bin/bash


ycsb_leveldb_function()
{
    interval=1
    i=1
    end=5

    mkdir results/leveldb2

    while [ $i -le $end ]; do
        if [ "$i" -lt "100" ]; then
            txr_out="0""$i"
        else
            txr_out="$i"
        fi
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "leveldb2/$i"_"leveldb2" -s 300 -w rw_d.spec
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




#ycsb_leveldb_function
#ycsb_couchdb_function

smallbank_couchdb_function
smallbank_leveldb_function