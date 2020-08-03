##File Download Pass
masterAdd <- read.csv('https://opendata.arcgis.com/datasets/dd9c7d93ed67438baefa3276c716f59d_5.csv',
                      stringsAsFactors = FALSE)

write.csv(masterAdd, 'DataInput/Master_Address_Table.csv', row.names = FALSE)

realBase <- read.csv('https://opendata.arcgis.com/datasets/bc72d0590bf940ff952ab113f10a36a8_8.csv',
                     stringsAsFactors = FALSE)

write.csv(realBase, 'DataInput/Real_Estate_Base_Data.csv', row.names = FALSE)

realResDetails <- read.csv('https://opendata.arcgis.com/datasets/c7adfdab73104a01a485dec324adcafb_17.csv',
                      stringsAsFactors = FALSE)

write.csv(realResDetails, 'DataInput/Real_Estate_Residential_Details.csv', row.names = FALSE)

realComDetails <- read.csv('https://opendata.arcgis.com/datasets/17fbd0c459d84c71aa37b436d5231c0b_19.csv',
                      stringsAsFactors = FALSE)

write.csv(realComDetails, 'DataInput/Real_Estate_Commercial_Details.csv', row.names = FALSE)

parAreaDetails <- read.csv('https://opendata.arcgis.com/datasets/0e9946c2a77d4fc6ad16d9968509c588_72.csv',
                           stringsAsFactors = FALSE)

write.csv(parAreaDetails, 'DataInput/Parcel_Area_Details.csv', row.names = FALSE)

parPoints <- read.csv('https://opendata.arcgis.com/datasets/d11cb8b656164c85bce532cd2f2809ea_74.csv',
                           stringsAsFactors = FALSE)

write.csv(parPoints, 'DataInput/Parcel_Owner_Points.csv', row.names = FALSE)

##API Pass




