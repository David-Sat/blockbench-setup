#! /usr/bin/env python

import sys
import re
import os
import glob
import csv
import pandas as pd
import numpy as np
from tabulate import tabulate

columns = ['Benchmark', 'WLType', 'MsgCount', '#Threads', 'TxRate', 'Latency per tx', 'Throughput', 
    'SuccessTxs%', 'FailedTxs%', 'MVCC%', 'Phantom%', 'Endorsement%', 
    'SuccessTxs', 'FailedTxs', 'MVCCConflicts', 'PhantomReads', 'EndorseFail', 'Seconds']

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
        
        txs = re.findall(r"tx count = (\d*\.\d+|\d+)", file_contents)
        txs = map(int, txs)
        txcount = sum(txs)
        
        outstanding_requests = re.findall(r"outstanding request = (\d*\.\d+|\d+)", file_contents)
        outstanding_requests.pop(0)

        # transaction counts
        successful = re.findall(r" V: ([0-9]+)", file_contents)
        ENDORSEMENT = re.findall(r" E: ([0-9]+)", file_contents)
        MVCC = re.findall(r" M: ([0-9]+)", file_contents)
        PHANTOM = re.findall(r" P: ([0-9]+)", file_contents)

        successful.pop(0)
        ENDORSEMENT.pop(0)
        MVCC.pop(0)
        PHANTOM.pop(0)

        txs_succ = sum(map(float,successful))
        txs_endo = sum(map(float,ENDORSEMENT))
        txs_mvcc = sum(map(float,MVCC))
        txs_phan = sum(map(float,PHANTOM))

        txs_all = txs_succ + txs_endo + txs_mvcc + txs_phan
        txs_succ_perc = txs_succ / txs_all
        txs_endo_perc = txs_endo / txs_all
        txs_mvcc_perc = txs_mvcc / txs_all
        txs_phan_perc = txs_phan / txs_all


        #latency
        lat = re.findall(r"latency = (\d*\.\d+|\d+)", file_contents)
        lat.pop(0)
        lat_float = map(float, lat)
        latency = sum(lat_float) / txs_succ

        # time
        time = re.findall(r" s: ([0-9]+).", file_contents)
        if not time:
            time = re.findall(r"stimeout=(\d*)", file_contents)

        
        seconds=int(time[-1])
        throughput=(txs_succ / seconds)
        #throughput = int(throughput)

        # message count
        filename = os.path.split(filepath)[-1]
        file_info = re.findall(r"([0-9]+)_", filename)
        if not file_info:
            msgcount = 0
        else:
            msgcount = file_info[0]
        

        result_collection = [benchmark, workloadType, msgcount, threads, txrate, latency, throughput, 
            txs_succ_perc, (txs_endo_perc + txs_mvcc_perc + txs_phan_perc), txs_mvcc_perc, txs_phan_perc, txs_endo_perc,
            txs_succ, (txs_endo + txs_mvcc + txs_phan), txs_mvcc, txs_phan, txs_endo, seconds]

        return result_collection




def writeCSV(result_list, output_name):
    csv_filename = output_name + ".csv"


    with open(csv_filename, mode='w') as benchmark_file:
        benchmark_writer = csv.writer(benchmark_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        benchmark_writer.writerow(columns)

        for result in result_list:
            benchmark_writer.writerow(result)

    
def writeCSVpandas(result_list, output_name):
    csv_filename = output_name + ".csv"

    bmresults = pd.DataFrame(result_list, columns=columns)
    bmresults.to_csv(csv_filename, float_format='%g')


def main():
    if len(sys.argv) != 2 or sys.argv[1] == '-h':
        print ("Usage: %s outputDirectory" % sys.argv[0])
        print ("Statistics (.result file) for each workload " + \
              "will be written to the specified output directory")
        
    path = sys.argv[1]
    result_out = sys.argv[2]
    txt_result_outputname = result_out + ".result"

    results = []

    print(path)
    for output in sorted(glob.glob(path + '/*.txt')):
        print(output)

        results.append(parseFile(output))

    print(tabulate(results, headers=columns))

    # Write txt based result
    out_file = open(os.path.join(path, txt_result_outputname), 'w+')
    out_file.write(tabulate(results, headers=columns))
    
    # Write csv result
    writeCSVpandas(results, result_out)


main()

