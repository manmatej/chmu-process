library(purrr)
library(sf)

# this script is using station ids generated in "poloha_stanic_merge.R" also available in this repo 
setwd("your//directory")
setwd("d://Git/chmu-process/")

# load output of previous script
stanice<-read.table("stanice_kraje_ids.csv",sep = ";",stringsAsFactors = F,header = T) 
# extract station ids
id<-as.character(stanice$nam)
id2<-as.character(stanice$id)


setwd("d:/temp_meteo/") # where should be zips stored
## daily max air temperature
#############################

ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/TMA-21.00/" # url base
uri<-paste0(ur,id,"_TMA_N.csv.zip")
nam<-paste0("tmax_day_",id2,".zip") # construct download names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip not existing urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tmax_day_*") # load downloaded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add flag the data exists 
                   tmax=rep("tmax",length(files)))

stanice1<-merge(stanice,downed,by="id",all.x = T) # merge with station data

## daily mean air temperature
#############################

ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/T-AVG/" # url base
uri<-paste0(ur,id,"_T_N.csv.zip")
nam<-paste0("tavg_day_",id2,".zip") # construct download names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip not existing urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tavg_day_*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add flag the data exists 
                   tavg=rep("tavg",length(files)))

stanice2<-merge(stanice1,downed,by="id",all.x = T) # merge with sttaion data


## daily min air temperature
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/TMI-21.00/" # url base
uri<-paste0(ur,id,"_TMI_N.csv.zip") # sign of max temp
nam<-paste0("tmin_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "tmin_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   tmin=rep("tmin",length(files)))

stanice3<-merge(stanice2,downed,by="id",all.x = T) # merge with sttaion data

## daily mean air humidity
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA//H-AVG/" # url base
uri<-paste0(ur,id,"_H_N.csv.zip") # sign of max temp
# writeClipboard(uri[10]) # test
nam<-paste0("hmean_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "hmean_day*") # load downaloded file names
downed<-data.frame(id=substr(files,11,18), # extract id, add sign of data exists 
                   humid=rep("humid",length(files)))

stanice4<-merge(stanice3,downed,by="id",all.x = T) # merge with sttaion data

# daily sum precipitation
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/SRA-07.00/" # url base
uri<-paste0(ur,id,"_SRA_N.csv.zip") # sign of max temp
nam<-paste0("prec_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "prec_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   prec=rep("prec",length(files)))

stanice5<-merge(stanice4,downed,by="id",all.x = T) # merge with sttaion data

# daily snow height
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/SCE-07.00/" # url base
uri<-paste0(ur,id,"_SCE_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("snow_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "snow_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   snow=rep("snow",length(files)))

stanice6<-merge(stanice5,downed,by="id",all.x = T) # merge with sttaion data

# daily sun duration
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/SSV-00.00/" # url base
uri<-paste0(ur,id,"_SSV_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("solr_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "solr_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   solr=rep("solr",length(files)))

stanice7<-merge(stanice6,downed,by="id",all.x = T) # merge with sttaion data


# daily mean wind speed
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/F-AVG/" # url base
uri<-paste0(ur,id,"_F_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("wind_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "wind_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   wind=rep("wind",length(files)))

stanice8<-merge(stanice7,downed,by="id",all.x = T) # merge with sttaion data

# daily mean air pressure
#############################
ur<-"https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/P-AVG/" # url base
uri<-paste0(ur,id,"_P_N.csv.zip") # sign of max temp
writeClipboard(uri[1]) # test
nam<-paste0("pres_day_",id2,".zip") # construct dwnload names

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = T)) # construct envelope to skip broken urls
purrr::walk2(uri, nam, safe_download) # walk through valid urls and save.

files<-list.files(pattern = "pres_day*") # load downaloded file names
downed<-data.frame(id=substr(files,10,17), # extract id, add sign of data exists 
                   pres=rep("pres",length(files)))

stanice9<-merge(stanice8,downed,by="id",all.x = T) # merge with sttaion data
stanice9$params<-apply(stanice9[,18:26], MARGIN = 1, function(x) sum(!is.na(x)))
stanice_sf<-st_as_sf(stanice9,coords = c("X", "Y"), crs = 4326 )

setwd("d://Git/chmu-process/")
write_sf(stanice_sf,"stanice_data.gpkg")
write.table(stanice9,"stanice_data.csv",sep = ";",col.names = T,row.names = F)
which(stanice9$params==0) ## incorrect region??

# summary
su<-unlist(stanice9[,18:26])
su<-su[!is.na(su)]
su<-summary(as.factor(su))
write.table(su,"clipboard")

