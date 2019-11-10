#!/bin/bash


Real_Estate_Commercial_Details="data/Real_Estate_Commercial_Details.csv"
Real_Estate_Residential_Details="data/Real_Estate_Residential_Details.csv"
Real_Estate_Base_Data="data/Real_Estate_Base_Data.csv"
Real_Estate_Area="data/Real_Estate_Area.csv"

# download
echo "downloading"
mkdir -p data
wget -O $Real_Estate_Base_Data https://opendata.arcgis.com/datasets/bc72d0590bf940ff952ab113f10a36a8_8.csv -o merge_data.log
wget -O $Real_Estate_Residential_Details https://opendata.arcgis.com/datasets/c7adfdab73104a01a485dec324adcafb_17.csv -o merge_data.log
wget -O $Real_Estate_Commercial_Details https://opendata.arcgis.com/datasets/17fbd0c459d84c71aa37b436d5231c0b_19.csv -o merge_data.log
wget -O $Real_Estate_Area https://opendata.arcgis.com/datasets/0e9946c2a77d4fc6ad16d9968509c588_72.csv -o merge_data.log

# run script
echo "merging data"
python3 merge_data.py \
 parcel_area $Real_Estate_Area  \
 real_estate_commercial $Real_Estate_Commercial_Details \
 real_estate_residential $Real_Estate_Residential_Details \
 real_estate_base $Real_Estate_Base_Data 

 echo "done"