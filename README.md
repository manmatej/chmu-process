## Series of scripts to handle CHMU data

### Poloha stanic merge
This script build upon Oto Kalab’s one, you can find here https://github.com/kalab-oto/chmu-poloha-stanic Use this script to merge into single file and filter duplicates. The output is also in this repository. You can simply download to proceed with downloading data. (stanice_ids.csv)

### Downloading script
To run this one, you need ids of stations. You can process them yourself or use “stanice_ids.csv” Script will download I hope all data, or you can decide which data. See: http://portal.chmi.cz/historicka-data/pocasi/denni-data/Denni-data-dle-z.-123-1998-Sb.#  
Result is bunch of zip files. 

### Unzip process
This one will handle downloaded zips. Only mean air temperature as example. Unzip, and process into flat data frame starting 01.01.1961 ending 31.01.2019. 

### Missing values
There are a lot of missing data, individual station vary in logging period. Y axis shows stations, X axis time. 

![image of missing data](airTmean2.jpg)

### Various staion location in time
In scripts I ignored variabe position of measuring point in time. Inside CSV files, there are aditional metadata like precise coordinates of measuring device in time. My scripts ignores it and simply merge all data by station ID ignorig spatial shift. 