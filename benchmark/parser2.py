#! /usr/bin/env python

import sys
import re
import os
import glob
import numpy as np
from tabulate import tabulate

columns = ['Benchmark', 'WorkloadType', '#Threads', 'TxRate', 'Seconds', 'Latency', 'Throughput', 
    'SuccessTxs', 'FailedTxs', 'MVCCConflicts', 'PhantomReads',
    'EndorseFailures']

def parseFile(filepath):
    with open(filepath) as file:
        file_contents = file.read()

        benchmark = re.findall(r"benchmark=(\w*)", file_contents)[0]
        workloadTypeList = re.findall(r"workload=(\w*).spec", file_contents)
        if not workloadTypeList:
            workloadTypeList = ['none']
        workloadType = workloadTypeList[0]
        threads = re.findall(r"threads=(\d*)", file_contents)[0]
        txrate = re.findall(r"txrate=(\d*)", file_contents)[0]
        time = re.findall(r"stimeout=(\d*)", file_contents)
        
        txs = re.findall(r"tx count = (\d*\.\d+|\d+)", file_contents)
        txs = map(int, txs)
        txcount = sum(txs)
        lat = re.findall(r"latency = (\d*\.\d+|\d+)", file_contents)
        lat_float = map(float, lat)
        latency = sum(lat_float) / len(lat)
        outstanding_requests = re.findall(r"outstanding request = (\d*\.\d+|\d+)", file_contents)

        successful = re.findall(r" V: ([0-9]+)", file_contents)
        ENDORSEMENT = re.findall(r" E: ([0-9]+)", file_contents)
        MVCC = re.findall(r" M: ([0-9]+)", file_contents)
        PHANTOM = re.findall(r" P: ([0-9]+)", file_contents)

        txs_succ = sum(map(int,successful))
        txs_endo = sum(map(int,ENDORSEMENT))
        txs_mvcc = sum(map(int,MVCC))
        txs_phan = sum(map(int,PHANTOM))

        if not time:
            seconds=0
            throughput=0
        else:
            seconds=int(time[0])
            throughput=(txs_succ / seconds)
        
        #polled_block = re.findall(r"(\d*\.\d+|\d+) txs", file_contents)

        result_col = [benchmark, workloadType, threads, txrate, seconds, latency, throughput, txs_succ, (txs_endo + txs_mvcc + txs_phan), txs_mvcc, txs_phan, txs_endo]

        return result_col


def main():
    if len(sys.argv) != 2 or sys.argv[1] == '-h':
        print ("Usage: %s outputDirectory" % sys.argv[0])
        print ("Statistics (.result file) for each workload " + \
              "will be written to the specified output directory")
        
    path = sys.argv[1]
    result_out = sys.argv[2]

    results = []

    print(path)
    for output in sorted(glob.glob(path + '/*.txt')):
        print(output)
        results.append(parseFile(output))

    print(tabulate(results, headers=columns))

    out_file = open(os.path.join(path, result_out), 'w+')
    out_file.write(tabulate(results, headers=columns))


main()

