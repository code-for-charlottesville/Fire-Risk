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

PARCEL_AREA_DETAILS = "parcel_area"
REAL_ESTATE_COMMERCIAL_DETAILS = "real_estate_commercial"
REAL_ESTATE_RESIDENTIAL_DETAILS = "real_estate_residential"
INDEX = "parcelnumber"


def _normalizeCol(csvName, col):
    """
    returns shared attribute name is it is one
    """
    col = col.lower()
    sharedAttributes = ["parcelnumber", "usecode", "yearbuilt"]
    if col in sharedAttributes: return col
    # add suffix if not standardized
    return "{}-{}".format(csvName, col)


def _fieldIsWanted(csvName, col):
    """
    determines if field is wanted based on the csv name
    """
    col = col.lower()
    if csvName == PARCEL_AREA_DETAILS:
        return col in [
            "objectid", "assessment", "geoparcelidentificationnumber",
            "legaldescription", "lotsquarefeet", "parcelnumber", "zoning",
            "esr_oid"
        ]

    if csvName == REAL_ESTATE_COMMERCIAL_DETAILS:
        return col in [
            "recordid_int",
            "parcelnumber",
            "usecode",
            "yearbuilt",
            "grossarea",
            "storyheight",
            "numberofstories",
        ]

    if csvName == REAL_ESTATE_RESIDENTIAL_DETAILS:
        return col in [
            "recordid_int",
            "parcelnumber",
            "usecode",
            "style",
            "grade",
            "roof",
            "flooring",
            "heating",
            "fireplace",
            "yearbuilt",
            "totalrooms",
            "bedrooms",
            "halfbathrooms",
            "fullbathrooms",
            "basementgarage",
            "basement",
            "finishedbasement",
            "basementtype",
            "externalwalls",
            "numberofstories",
            "squarefootagefinishedliving",
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

    # return this chart if there's nothing in the current chart
    if len(mergedCsv.index) == 0:
        return df
    # else return merged CSV on index
    merged = mergedCsv.join(df.set_index(INDEX), on=[INDEX])
    # drop duplicates, if any
    merged.drop_duplicates(subset=[INDEX], inplace=True)
    return merged


if __name__ == '__main__':
    # parse args
    if len(sys.argv) < 2 or sys.argv[1] == "--help":
        print(USAGE)
        sys.exit(1)
    # init data file
    logging.basicConfig(level=logging.DEBUG)
    # start merge
    mergedCsv = pd.DataFrame()
    for i in range(1, len(sys.argv), 2):
        csv = sys.argv[i + 1]
        name = sys.argv[i]
        mergedCsv = _mergeInData(csv, name, mergedCsv)
        logging.debug("merged in chart {}:\n{}".format(name, mergedCsv))
    # output csv to file
    mergedCsv.to_csv("merged.csv", index=INDEX)
