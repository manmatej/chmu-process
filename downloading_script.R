
library(rvest)
library(stringr)
library(xml2)
library(purrr)

## URL mining --------------------------------------------

# scrap element codes  
base <- "https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/denni_data_cs.html"
page <- read_html(base)

page.list<-page %>%
  html_elements("a") %>%  # find all links on the page
  html_attr("href")       # get the urls

page.list<-page.list[grep("kraje",page.list)] # select only url containing region names
a<-strsplit(page.list,"/") # parse result for extracting element codes
element<-sapply(a,function(x) x[2]) # extract element codes

## scrap region names 
base2 <- paste0("https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA/",page.list[1])
page2<-read_html(base2,encoding = "latin1")

page.list2<-page2 %>%
  html_elements("a") %>%  # find all links on the page
  html_attr("href")       # get the urls

page.list2<-page.list2[grep(".html",page.list2)] # extract only regions
a<-strsplit(page.list2,"/") # parse result for extracting region names
region<-sapply(a,function(x) x[2]) # extract region names

## urls for scrapping csv names (combine element + region) 
base4 <- "https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA"
base5<-paste(base4,element,"HTML",sep="/") # combine base url with element
element.region<-as.vector(outer(base5,region, paste, sep="/")) # combine all elements url (11) with all regions (14)


## get csv files URL
result<-list() # empty list for storing the result
for (i in 1:length(element.region)){
  pg<-read_html(element.region[i],encoding = "latin1") # read html page region-element table
  pgls<-pg %>%
    html_elements("a") %>%  # find all links on the region-element table page
    html_attr("href")       # get the links from region-element table page
  pgls<-unique(pgls)        # remove duplicated links
  a<-strsplit(pgls,"/")     # parse url to be able to extract csv file name
  b<-sapply(a,function(x) x[3]) # extract file name from parsed url
  aa<-unlist(strsplit(element.region[i],"/")) # parse url to be able to extract region name and element code
  result[[i]]<-paste("https://www.chmi.cz/files/portal/docs/meteo/ok/open_data/RDATA", # base URL
                     aa[11], # element code
                     substr(aa[13],1,nchar(aa[13])-5), # region name
                     b, # file name
                     sep="/")
}

result.unique<-unique(unlist(result)) # remove duplicits if there were some
result.zip<-result.unique[grep(".zip",result.unique)] # remove useless links

# construct names
n<-sapply(strsplit(result.zip,"/"),function(x) x[11])
a<-sapply(strsplit(result.zip,"/"),function(x) x[12])
m<-sapply(strsplit(result.zip,"/"),function(x) x[13])
nam<-paste(n,a,m,sep="_")
nam<-make.names(nam)
sum(duplicated(nam))

## Downloading --------------------------------------------

setwd("d:/temp_meteo/") # where should be zips stored

safe_download <- purrr::safely(~ download.file(.x , .y, mode = "wb",quiet = F)) # construct envelope to skip not existing urls
purrr::walk2(.x=result.zip,nam, .f=safe_download) # walk through valid urls and save.


