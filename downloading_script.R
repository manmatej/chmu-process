library("purrr")
library(sf)

# this script is using station ids generated in "poloha_stanic_merge.R" also available in this repo 
setwd("your//directory")

# load output of previous script
stanice<-read.table("stanice_ids.csv",sep = ";",stringsAsFactors = F,header = T) 
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
stanice9$params<-apply(stanice9[,16:24], MARGIN = 1, function(x) sum(!is.na(x)))
stanice_sf<-st_as_sf(stanice9,coords = c("X", "Y"), crs = 4326 )

which(apply(stanice9[16:24], MARGIN = 1, function(x) sum(!is.na(x)))==0)

write_sf(stanice_sf,"2020_05_05_stanice_data.gpkg")
write.table(stanice9,"2020_05_05_stanice_data.csv",sep = ";",col.names = T,row.names = F)
