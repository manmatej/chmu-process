
loc<-"d:/temp_meteo/unzip/"
setwd(loc)

files<-list.files(loc) # load csv files with maximum temperature
names<-list.files(loc,full.names = F)
element<-substr(names,10,nchar(names)-4)
summary(as.factor(element))


## coordinates and mesuring period metadata 
lines<-lapply(files, readLines,n=100) # read first 100 lines where metadata must be
start<-lapply(lines, grep,pattern="METADATA") # find start line of metadata
start<-unlist(start)+1 
end<-lapply(lines, grep,pattern="PŘÍSTROJE") # find end line of metadata
end<-unlist(end)-2

# extract all target metadata lines in paralel loop
library(foreach)
library(doParallel)

cores=detectCores() # detect cores
cl <- makeCluster(cores[1]-1) # use all cores excpet of one (prevent owerloading)
registerDoParallel(cl) # register cluster

# dynamic extract of certainlines from metadata and bind into one matrix
finalMatrix <- foreach(i=1:length(files), .combine=rbind) %dopar% {
  tempMatrix = read.table(text=unlist(lines[i])[start[i]:end[i]],sep=";",header=T,dec = ",")
  tempMatrix$element<-rep(element[i],nrow(tempMatrix))
  tempMatrix #Equivalent to finalMatrix = rbind(finalMatrix, tempMatrix)
}

stopCluster(cl) #stop cluster
finalMatrix$Začátek.měření<-as.POSIXct(finalMatrix$Začátek.měření,"%d.%m.%Y", tz = "UTC")
finalMatrix$Konec.měření<-as.POSIXct(finalMatrix$Konec.měření,"%d.%m.%Y", tz = "UTC")

coordinates<-finalMatrix
coordinates<-coordinates[!is.na(coordinates$Zeměpisná.šířka),]
head(coordinates)

setwd("d://Git/chmu-process/")
saveRDS(coordinates,file = "coords_time.rds")
write.table(coordinates,col.names = T,row.names = F,sep=",",
            file = "coords_time.csv")
st_write(coordinates,"coords_time.gpkg")

## visual check - station moving in time
# devtools::install_github('rstudio/leaflet')
library(leaflet)
library(sf)
library(randomcoloR)


coo.sf<-st_as_sf(coordinates, coords = c("Zeměpisná.délka","Zeměpisná.šířka"),crs = 4326)
plot(st_geometry(coo.sf))
unik<-unique(coo.sf$Stanice.ID)

col=colorFactor(sample(colors(),length(unik),replace = T),domain = NULL)
pop<-paste0(coo.sf$Jméno.stanice," ",coo.sf$element," ",coo.sf$Začátek.měření," ",coo.sf$Konec.měření)

# interactiv map
leaflet(coo.sf) %>% 
  addTiles() %>%  
  addCircleMarkers(popup=pop,color = ~col(Stanice.ID),
                   stroke = FALSE, fillOpacity = 0.8,radius=4)


#### subset coordinates based on time and element ------------
# example: find all stations measuring continuously mean air temperature from 2017 till 2020
coordinates<-readRDS("coords_time.rds")
data<-coordinates[coordinates$element=="T_N",]
start<-as.POSIXct("2017-01-01")
end<-as.POSIXct("2020-01-01")

data<-data[data$Začátek.měření<start & data$Konec.měření>end,]
which(duplicated(data$Stanice.ID))
head(data)

# example: find last known position of all stations measuring mean air temperature
data<-coordinates[coordinates$element=="T_N",]

data.ord<-data[order(data[,'Stanice.ID'],data[,"Konec.měření"],decreasing = T),] # sort stations by ID and time
data.ord<-data.ord[!duplicated(data.ord$Stanice.ID),] # select first record (last known position)



