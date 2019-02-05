library(RODBC)
library(ggplot2)
library(maps)
library(ggthemes)
library(tibble)
library(lubridate)
library(gganimate)
library(gifski)
library(animation)
library(readr)
library(dplyr)
library(DT)

#dat -> a data set consisting of lat/longs, dates and a weight column

#make sure date is in correct format
dat$date = as.Date(dat$date)

#order so that data is in order of dates
dat<-arrange(dat,created_at)

#add index
dat$ind<-(1:nrow(dat))

#get map of leaflet
world <- map_data("world")
world <- arrange(world,order)

#Print graph at different time intervals cummulatively and save the outputs as frames into a GIF
invisible(saveGIF({
  for (i in dat$ind){
    map <- ggplot(world, aes(x = long, y =lat, group = group)) + 
      geom_polygon(col = "Black", fill = 'grey')+theme_map()+
      geom_point(inherit.aes = FALSE,aes(x = lon, y = lat, size = weight),
                 data = filter(dat, ind<=i), colour = 'purple', alpha = .5) +
      scale_size_continuous(range = c(1, 8), breaks = c(250, 500, 750, 1000)) +
      labs(size = 'Weight', title=dat$date[i])
    print(map)
  }
}, movie.name = "map.gif", interval = 1, ani.width = 1000, ani.height = 700))


