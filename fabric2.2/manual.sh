#!/bin/bash


leveldb_function()
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

couchdb_function()
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

leveldb_function

couchdb_function