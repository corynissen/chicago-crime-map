
library(ggplot2)
library(OpenStreetMap)

##############################################################################
# Read the data
##############################################################################

# x2n5-8w5q is crimes in past year in Chicago data set
df <- read.csv("http://data.cityofchicago.org/views/x2n5-8w5q/rows.csv",
               stringsAsFactors = F) 
names(df) <- tolower(names(df))

# we don't want missing values in lat or lon
df <- subset(df, !is.na(longitude) & !is.na(latitude))

##############################################################################
# Do some plots
##############################################################################

# the shape of chicago, no underlying shape, just x,y points
ggplot(df) + geom_point(aes(x=longitude, y=latitude), alpha=.2, size=.9)
ggsave("chicago_crime_map_no_underlay.jpg")

# now, let's put the shape of chicago underneath the points
rlat <- range(df$latitude)
rlon <- range(df$longitude)
merc <- projectMercator(df$latitude, df$longitude) #OSM uses mercator
# give openmap the upper right and lower left corners you want for your map
mp <- openmap(c(rlat[2], rlon[1]), c(rlat[1], rlon[2]), type="osm")
autoplot(mp) + geom_point(aes(x=merc[,1], y=merc[,2]), alpha=.1, size=.9)
ggsave("chicago_crime_map_osm_underlay.jpg")
