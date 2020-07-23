#! /usr/bin/env python

import sys
import re
import os
import numpy

from tabulate import tabulate


#result_dir = "workloads"
#result_dir = '/home/david/analysis/laptop-results'
#result_dir = '/home/david/blockbench/src/macro/smallbank'
result_dir = '/home/david/blockbench/src/macro/kvstore'

columns = ['WorkloadType', '#Threads', 'Latency', 'Throughput', 
    'SuccessTxs', 'FailedTxs', 'MVCCConflicts', 'PhantomReads',
    'EndorseFailures']



# TODO: workload type through name of file
# TODO: number of threads through name of file

def main():
    if len(sys.argv) != 2 or sys.argv[1] == '-h':
        print "Usage: %s OutputFileName" % sys.argv[0]
        print "Statistics (.result file) for each workload " + \
              "will be written to %s" % result_dir
        #sys.exit(-1)

    #path = sys.argv[1]
    
    #path = '/home/david/blockbench/src/macro/smallbank/output_sb.txt'
    path = '/home/david/blockbench/src/macro/kvstore/output_kv.txt'

    wl = "smallbank"



    with open(path) as file:
        file_contents = file.read()
        
        txs = re.findall(r"tx count = (\d*\.\d+|\d+)", file_contents)
        txs = map(int, txs)
        print(txs)
        txcount = sum(txs)
        latency = re.findall(r"latency = (\d*\.\d+|\d+)", file_contents)
        outstanding_requests = re.findall(r"outstanding request = (\d*\.\d+|\d+)", file_contents)

        successful = re.findall(r"Successful: (\d)", file_contents)
        ENDORSEMENT = re.findall(r"ENDORSEMENT: ([0-9]+)", file_contents)
        MVCC = re.findall(r"MVCC: ([0-9]+)", file_contents)
        PHANTOM = re.findall(r"PHANTOM: ([0-9]+)", file_contents)

        txs_succ = sum(map(int,successful))
        txs_endo = sum(map(int,ENDORSEMENT))
        txs_mvcc = sum(map(int,MVCC))
        txs_phan = sum(map(int,PHANTOM))
        
        #polled_block = re.findall(r"(\d*\.\d+|\d+) txs", file_contents)

        results = ['todo', 'todo', latency[-1], 'todo', txs_succ, (txs_endo + txs_mvcc + txs_phan), txs_mvcc, txs_phan, txs_endo]

        print(tabulate([results], headers=columns))

        out_file = open(os.path.join(result_dir, wl + ".result"), 'w+')
        out_file.write(tabulate([results], headers=columns))

        print(outstanding_requests)


main()



            