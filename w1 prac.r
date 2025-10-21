library(sf)
library(tmap) 
library(tmaptools)
library(RSQLite)
library(tidyverse)
#read in the shapefile

shape <- st_read(
  "/Users/mixednutgiftpack/Library/Mobile Documents/com~apple~CloudDocs/USS/005/W1/statsnz-territorial-authority-2018-generalised-SHP/territorial-authority-2018-generalised.shp")
# read in the csv
mycsv <- read_csv("/Users/mixednutgiftpack/Library/Mobile Documents/com~apple~CloudDocs/USS/005/W1/paid_emply.csv")

# merge csv and shapefile
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="TA2018_V1", 
        by.y="code")

# set tmap to plot
tmap_mode("plot")
# have a look at the map
qtm(shape, fill = "sum_Paid employee")
# write to a .gpkg
shape %>%
  st_write(.,"//Users/mixednutgiftpack/Library/Mobile Documents/com~apple~CloudDocs/USS/005/W1/paid_emply.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)
# connect to the .gpkg
con <- dbConnect(SQLite(),dbname="/Users/mixednutgiftpack/Desktop/Week1/Rwk1.gpkg")
# list what is in it
con %>%
  dbListTables()
# add the original .csv
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()

