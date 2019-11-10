# Merge_CSV

This directory contains the development environment for merging in multiple csv files from the [charlottesville open data portal]([https://opendata.charlottesville.org](https://opendata.charlottesville.org/)) into a singular, large csv file and postgres database.

## Fields

- Every row in this data is based on a [parcel identification number]([https://en.wikipedia.org/wiki/Assessor%27s_parcel_number](https://en.wikipedia.org/wiki/Assessor's_parcel_number)), since all rows in the original data are also tied to that ID. This is the index of the overall DB. There should not be any duplicate PINs. 
- The only shared attributes I was able to find were "ParcelNumber" (shared by all original data), "usecode" (shared by residential/commercial), and "yearbuilt" (shared by residential/commercial).

The outputfile is in the root of this directory [merged.json](./merged.json). 

## Run it

```bash
# start environment
docker-compose up -d --build
# install
sudo pip3 install -r requirements.txt
# run bash script
./run.sh
...
```



## Authors

- David Goldstein [dgoldstein1](https://github.com/dgoldstein1)

