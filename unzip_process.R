
# read output of downloading script

loc<-"path\\to\\ypur\\zips"
loc<-"d:\\temp_meteo\\"
zips<-list.files(loc,pattern = "*.zip$",full.names = T) # list paths to all zip files in current directory

unzips<-"path\\to\\folder\\where\\to\\write\\unpacked"
unzips<-"d:\\temp_meteo\\unzip"
setwd(unzips)

for (i in 1:length(zips)){
  unzip(zips[i],exdir=unzips)  # unzip your file 
}


library(data.table)

## mean air temperature
files<-list.files(unzips,pattern = "*_T_N.csv$",full.names = T) # load files based on pattern
files.names<-list.files(unzips,pattern = "*_T_N.csv$",full.names = F) # load files based on pattern
years<-lapply(files,fread,skip = "Měsíc",header = T, dec=",",select=1) # find absolute start + end date
min(unlist(lapply(years,min,na.rm=T)))
max(unlist(lapply(years,min,na.rm=T)))

# generate clear time series by day
prvni<-as.POSIXct("1961-01-01",tz="UTC") # start time
posledni<-as.POSIXct("2021-12-31",tz="UTC") # end time
cas<-seq(from=prvni,to=posledni, by=60*60*24) # generate clear time series
 
## clear data frame for joining data together
airTmean<-data.frame(date=cas)
airTmean$date<-as.character(airTmean$date)

records<-lapply(files,fread,skip = "Měsíc",header = T, dec=",",select=c(1:4)) 
# read all csv files starting with line where string "měsíc" is found
# did not not work with "Rok" because of "Rokytnice nad Jizerou"

for (i in 1:length(files)) {
  tm<-data.frame(records[[i]]) # single data frame
  loc<-substr(files.names[i],1,8) # station id
  datum<-paste(tm$Rok,tm$Měsíc,tm$Den,sep="-") # construct posix date
  pos<-as.POSIXct(datum)
  cha<-as.character(pos) # convert to character, merge not works with posix
  tms<-data.frame(date=cha,mer=tm$Hodnota) # single station ready for merge
  names(tms)<-c("date",loc)
  airTmean<-merge(airTmean,tms,by="date",all.x = T) # final merge
}

setwd("d://Git/chmu-process/")
save(airTmean,file="airTmean_merged.RData")
fwrite(airTmean,"airTmean.csv",sep=";")


airTmean$date<-as.POSIXct(airTmean$date)
a<-seq(1961,2021,by=1)

jpeg(filename = "airTmean.jpg",
     width = 2000, height = 500, units = "px",bg = "white",quality = 90)
image(as.matrix(airTmean[,-1]),axes=F)
axis(1, at=seq(0,1,length.out = length(a)), labels=a,las=3)
dev.off()

