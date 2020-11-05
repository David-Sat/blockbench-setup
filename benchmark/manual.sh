#!/bin/bash



./startbenchmark.sh -b ycsb -t 100 -T 16 -o workloada1 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o workloada2 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o workloada3 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o workloada4 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o workloada5 -O localhost:7041 -P localhost:7051 -s 300 -w workloada.spec

./startbenchmark.sh -b donothing -t 100 -T 16 -o donothing1 -O localhost:7041 -P localhost:7051 -s 300 -w rw_k.spec
./startbenchmark.sh -b donothing -t 100 -T 16 -o donothing2 -O localhost:7041 -P localhost:7051 -s 300 -w rw_k.spec
./startbenchmark.sh -b donothing -t 100 -T 16 -o donothing3 -O localhost:7041 -P localhost:7051 -s 300 -w rw_k.spec
./startbenchmark.sh -b donothing -t 100 -T 16 -o donothing4 -O localhost:7041 -P localhost:7051 -s 300 -w rw_k.spec
./startbenchmark.sh -b donothing -t 100 -T 16 -o donothing5 -O localhost:7041 -P localhost:7051 -s 300 -w rw_k.spec

./startbenchmark.sh -b smallbank -t 100 -T 16 -o smallbank1 -n 1000000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300
./startbenchmark.sh -b smallbank -t 100 -T 16 -o smallbank2 -n 1000000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300
./startbenchmark.sh -b smallbank -t 100 -T 16 -o smallbank3 -n 1000000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300
./startbenchmark.sh -b smallbank -t 100 -T 16 -o smallbank4 -n 1000000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300
./startbenchmark.sh -b smallbank -t 100 -T 16 -o smallbank5 -n 1000000 -f stat.txt -O localhost:7041 -P localhost:7051 -s 300

./startbenchmark.sh -b ycsb -t 100 -T 16 -o sm_workload1 -O localhost:7041 -P localhost:7051 -s 300 -w sm_workload.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o sm_workload2 -O localhost:7041 -P localhost:7051 -s 300 -w sm_workload.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o sm_workload3 -O localhost:7041 -P localhost:7051 -s 300 -w sm_workload.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o sm_workload4 -O localhost:7041 -P localhost:7051 -s 300 -w sm_workload.spec
./startbenchmark.sh -b ycsb -t 100 -T 16 -o sm_workload5 -O localhost:7041 -P localhost:7051 -s 300 -w sm_workload.spec


