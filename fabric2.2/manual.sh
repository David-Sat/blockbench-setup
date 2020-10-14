#!/bin/bash


leveldb_function()
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
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "leveldb/$i"_"leveldb" -s 300 -w workloada.spec
        i=$(($i+$interval))
    done 
}

couchdb_function()
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
        ./solofabric.sh -b ycsb -t 100 -T 16 -o "couchdb/$i"_"couchdb" -s 300 -w workloada.spec -d couchdb
        i=$(($i+$interval))
    done 
}

leveldb_function

couchdb_function