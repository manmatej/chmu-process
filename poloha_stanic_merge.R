
## Use Oto Kalab's script to download station metadata
## https://github.com/kalab-oto/chmu-poloha-stanic

## merge into single layer

# stations
setwd("your\\directory") 
library(sf)
sta.layer<-as.list(st_layers("stanice.gpkg")$name) # gpkg layers names
a<-lapply(sta.layer,st_read,dsn="stanice.gpkg",stringsAsFactors=F) # list all layers
b<-do.call(rbind,a) # bind together

## remove duplicated ids
length(unique(b$id))
length(b$id)
dupl<-c(which(duplicated(b$id)),which(duplicated(b$id, fromLast=TRUE)))
b.dupl<-b[dupl,]

b<-b[!duplicated(b$id),]
stations<-b # without duplicites


# elements
ele.layer<-as.list(st_layers("staniceElement.gpkg")$name) # load all data into list
elem<-substr(st_layers("staniceElement.gpkg")$name,8,nchar(st_layers("staniceElement.gpkg")$name)-1)
aa<-lapply(ele.layer,st_read,dsn="staniceElement.gpkg",stringsAsFactors=F) 

xx<-do.call(rbind,aa) 
ids<-data.frame(id=unique(xx$id),idx=unique(xx$id),stringsAsFactors = F) # unique ids
cc<-lapply(aa,subset,select=c("id","ELEMENT")) # id plus element
dd<-lapply(cc, st_set_geometry,NULL) # remove geometry data
for (i in 1:8) colnames(dd[[i]])[2]<-elem[i] # naming elements

# merge elements together
for(i in 1:8){
  m1<-dd[[i]]
  m1<-m1[!duplicated(m1$id),]
  ids<-merge(ids,m1,all.x = T)
}

final<-merge(stations,ids,all.x=T)
final<-final[,-8] # remove duplicite column

## write result
write_sf(final,"2020_04_09_stanice_kalab.gpkg")
final1<-st_set_geometry(final,NULL)
write.table(final1,"2020_04_09_stanice_kalab.csv",sep = ";",col.names = T,row.names = F)


