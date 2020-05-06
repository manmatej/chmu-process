library("purrr")
library(sf)

# this script is using station ids generated in "poloha_stanic_merge.R" also available in this repo 
setwd("your//directory")
# load output of previous script
stanice<-read.table("2020_04_09_stanice_kalab.csv",sep = ";",stringsAsFactors = F,header = T) 

# extract station ids
id<-as.character(stanice$id)



## daily mean air temperature
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/T-AVG/" # url base
uri<-paste0(ur,id,"_T_N.csv.zip") # sign of mean temp
nam<-paste0("tmean_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip not existing urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tmean_day_*") # load downaloded file names
downed<-data.frame(id=substr(files,11,18), # extract id, add flag the data exists 
                   tmean=rep("tmean",length(files)))

stanice1<-merge(stanice,downed,by="id",all.x = T) # merge with sttaion data

## daily max air temperature
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/TMA-21.00/" # url base
uri<-paste0(ur,id,"_TMA_N.csv.zip") # sign of max temp
nam<-paste0("tmax_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tmax_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   tmax=rep("tmax",length(files)))

stanice2<-merge(stanice1,downed,by="id",all.x = T) # merge with sttaion data


## daily min air temperature
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/TMI-21.00/" # url base
uri<-paste0(ur,id,"_TMI_N.csv.zip") # sign of max temp
nam<-paste0("tmin_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tmin_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   tmin=rep("tmin",length(files)))

stanice3<-merge(stanice2,downed,by="id",all.x = T) # merge with sttaion data

## daily mean air humidity
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/H-AVG/" # url base
uri<-paste0(ur,id,"_H_N.csv.zip") # sign of max temp
# writeClipboard(uri[10]) # test
nam<-paste0("hmean_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "hmean_day*") # load downaloded file names
downed<-data.frame(id=substr(files,11,18), # extract id, add sign of data exists 
                   humid=rep("humid",length(files)))

stanice4<-merge(stanice3,downed,by="id",all.x = T) # merge with sttaion data

# daily sum precipitation
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/SRA-07.00/" # url base
uri<-paste0(ur,id,"_SRA_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("prec_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "prec_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   prec=rep("prec",length(files)))

stanice5<-merge(stanice4,downed,by="id",all.x = T) # merge with sttaion data

# daily snow height
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/SCE-07.00/" # url base
uri<-paste0(ur,id,"_SCE_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("snow_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "snow_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   snow=rep("snow",length(files)))

stanice6<-merge(stanice5,downed,by="id",all.x = T) # merge with sttaion data

# daily sun duration
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/SSV-00.00/" # url base
uri<-paste0(ur,id,"_SSV_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("solr_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "solr_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   solr=rep("solr",length(files)))

stanice7<-merge(stanice6,downed,by="id",all.x = T) # merge with sttaion data


# daily mean wind speed
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/F-AVG/" # url base
uri<-paste0(ur,id,"_F_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("wind_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "wind_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   wind=rep("wind",length(files)))

stanice8<-merge(stanice7,downed,by="id",all.x = T) # merge with sttaion data

# daily mean air pressure
#############################
ur<-"http://portal.chmi.cz/files/portal/docs/meteo/ok/denni_data/P-AVG/" # url base
uri<-paste0(ur,id,"_P_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("pres_day_",id,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "pres_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   pres=rep("pres",length(files)))

stanice9<-merge(stanice8,downed,by="id",all.x = T) # merge with sttaion data
stanice9$params<-apply(stanice9[16:24], MARGIN = 1, function(x) sum(!is.na(x)))
stanice_sf<-st_as_sf(stanice9,coords = c("X", "Y"), crs = 4326 )

which(apply(stanice9[16:24], MARGIN = 1, function(x) sum(!is.na(x)))==0)

write_sf(stanice_sf,"2020_05_05_stanice_data.gpkg")
write.table(stanice9,"2020_05_05_stanice_data.csv",sep = ";",col.names = T,row.names = F)


################ Read data ###############x

library(data.table)
loc<-"q:\\y_gis_data\\CR\\CHMU\\denni_data_19xx-2019_work"
setwd(loc)

## mean air temperature
files<-list.files(pattern = "*_T_N.csv$") # load files based on pattern

years<-lapply(files,fread,skip = "M?s?c",header = T, dec=",",select=1) # find absolute start and end date
min(unlist(lapply(years,min,na.rm=T)))
max(unlist(lapply(years,min,na.rm=T)))

# generate clear time series by day
prvni<-as.POSIXct("1961-01-01",tz="UTC") # start time
posledni<-as.POSIXct("2019-12-31",tz="UTC") # end time
cas<-seq(from=prvni,to=posledni, by=60*60*24)

## cler data frame for joining data together
airTmean<-data.frame(date=cas)
airTmean$date<-as.character(airTmean$date)

records<-lapply(files,fread,skip = "M?s?c",header = T, dec=",",select=c(1:4)) 
# read all csv files starting with line where string "mes?c" is found
# didn not work with "Rok" because of "Rokytnice nad Jizerou"

for (i in 1:length(files)) {
  tm<-data.frame(records[[i]]) # single data frame
  loc<-substr(files[i],1,8) # staton id
  datum<-paste(tm$Rok,tm$M?s?c,tm$Den,sep="-") # construct posix date
  pos<-as.POSIXct(datum)
  cha<-as.character(pos) # conver to chcarcter, merge not works with posix
  tms<-data.frame(date=cha,mer=tm$Hodnota) # single station ready for merge
  names(tms)<-c("date",loc)
  airTmean<-merge(airTmean,tms,by="date",all.x = T) # final merge
}

save(airTmean,file="airTmean_merged.RData")

tiff(filename = "airTmean.tiff",
     width = 3000, height = 500, units = "px", compression = "lzw+p",bg = "white")
image(as.matrix(airTmean[,-1]))
dev.off()
