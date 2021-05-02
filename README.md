# Series of scripts to handle CHMI daily climate historical data
  
CHMI daily climatic data are currently available from 1961 to 2020 but with many missing data.
  
### 1. Downloading script
https://www.chmi.cz/historicka-data/pocasi/denni-data/Denni-data-dle-z.-123-1998-Sb
To run [Downloading script.R](./downloading_script.R), you need stations ID. By default I prepared table with the IDs [stanice_kraje_ids.csv](./stanice_kraje_ids.csv). In script [poloha_stanic_merge.R](./poloha_stanic_merge.R) you can check Where the station IDs comes from. You can process station IDs yourself or use default. Default will download (I hope) all data. Providing subset of station IDs you can decide which data download specifically. Downloading process result is bunch of zip files on your drive. 

### 2. Unzip and process data
[unzip_process.R](./unzip_process.R) will unzip downloaded files and  produce table where rows are days and columns station IDs. Only mean air temperature is provided as an example. You can easily modify for any other variable specifying variable name. Currently there are available:

| climatic element                 | number of stations with data |
|----------------------------------|------------------------------|
| Daily mean relative air humidity | 273                          |
| Sum of daily precipitation       | 718                          |
| Daily mean air pressure          | 57                           |
| Total depth of snow              | 707                          |
| Depth of daily fresh snow        | 705                          |
| Daily duration of sun shining    | 186                          |
| Daily mean air temperature       | 296                          |
| Daily maximal air temperature    | 279                          |
| Daily minimal air temperature    | 279                          |
| Daily mean  wind speed           | 250                          |
| Daily maximal wind speed         | 180                          |

For the list of stations with or without data available for specific element you can check the table: [stanice_data.csv](./stanice_data.csv) or the QGIS file [stanice_data.gpkg](./stanice_data.gpkg) 

### Missing values
There are a lot of missing data, individual station vary in logging period. The oldest data comes from 1. 1. 1961 and the newest from 31. 12. 2020. Almost none station mesured continunously for that period.   
Y axis shows stations, X axis time. 

![image of missing data](airTmean.jpg)


### Changing staion location through time
The script[poloha_stanic_merge.R](./poloha_stanic_merge.R) build upon Oto Kalab’s one, you can find here https://github.com/kalab-oto/chmu-poloha-stanic  For update with data 2020 I had to add also region name to be able to construct downloading URL therefor I extracted from nuts3 GIS layer. For the purpose of this repository I ignored variable position of stations in time (Yes, they were moving). Inside any of raw CSV file downloaded from CHMI, there are additional metadata like precise coordinates of measuring device in certain time or metadata on measuring instruments and units. My script ignores station moving and simply merge all data by station ID with current station position. You can check station position change in time in file [coords_time.csv](./coords_time.csv) which is in long format. When station was moved, there is a record with station ID and new coordinates for next period. Some stations were moved several times in last 60 years.
