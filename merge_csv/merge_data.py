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


def _formatColumnName(col):
    """
    Using camel case for column names
    """
    pass


def _normalizeCol(csvName, col):
    """
    returns shared attribute name is it is one
    """
    col = col.lower()
    if csvName == "parcel_area_details":
        if col == "geoparcelidentificationnumber": return "GPIN"
        if col == "parcelnumber": return "PIN"
        if col == "zoning": return "zoning"

    return col


def _fieldIsWanted(csvName, col):
    """
    determines if field is wanted based on the csv name
    """
    col = col.lower()
    if csvName == "parcel_area_details":
        return col in [
            "objectid", "assessment", "geoparcelidentificationnumber",
            "legaldescription", "lotsquarefeet", "parcelnumber", "zoning",
            "esr_oid"
        ]

    return False


def _mergeInData(csv, name, mergedCsv):
    """
    merges in data from csv into mergedCsv, passed by reference
    """
    logging.info("Reading in csv: %s", csv)
    df = pd.read_csv(csv)
    # first clean up columns in df
    for col in df.columns:
        # dont add if field isn't needed
        if _fieldIsWanted(name, col):
            # normalize to sharedAttributes, if needed
            df = df.rename(columns={col: _normalizeCol(name, col)})
        else:
            df = df.drop(columns=[col])

    logging.debug("updated columns in {}: {}".format(name, df.columns))
    # # if column is good, add value from each row
    # for index, row in df.iterrows():
    #     pass


if __name__ == '__main__':
    # parse args
    if len(sys.argv) < 2 or sys.argv[1] == "--help":
        print(USAGE)
        sys.exit(1)
    # init data file
    logging.basicConfig(level=logging.DEBUG)
    # start merge
    mergedCsv = None
    for i in range(1, len(sys.argv), 2):
        csv = sys.argv[i + 1]
        name = sys.argv[i]
        if _mergeInData(csv, name, mergedCsv) == False:
            logging.error("Error merging: %s", csv)
            sys.exit(1)
