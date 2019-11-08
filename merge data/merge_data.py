# !/bin/python3

import pandas as pd
import json
import logging
import sys


USAGE = """
Merge CSVs for fire-risk data

USAGE: 
	python3 merge_data.py [CSV_1_Name or --help] [CSV_1_Path] [CSV_2_Name] [CSV_2_Path] ...
"""

def mergeInData(csv, name, mergedCsv):
    """
    """
    logging.info("Reading in csv: %s", csv)
    df = pd.read_csv(csv)
    # loop through
    for index, row in df.iterrows():
        for col in df.columns:
            pass
    


if __name__ == '__main__':
    # parse args
    if len(sys.argv) < 2 or sys.argv[1] == "--help":
        print(USAGE)
        sys.exit(1)
    # init data file
    logging.basicConfig( level=logging.DEBUG)
    # start merge
    mergedCsv = None
    for i in range(1,len(sys.argv), 2):
        csv = sys.argv[i+1]
        name = sys.argv[i]
        if mergeInData(csv, name, mergedCsv) == False:
            logging.error("Error merging: %s", csv)
            sys.exit(1)
