library(ggplot2)
library(sf)
library(sp)
library(data.table)
library(tab)
library(broom)
library(raster)
library(wesanderson)
library(gtable)
library(ggpubr)
library(zoo)
library(collapse)
library(lubridate)
library(plm)
library(tidyr)
library(DataCombine)
library(Hmisc)
library(stargazer)
library(psych)
library(tidyverse)
library(descr)
library(dplyr)

### Path of the local directory #####

setwd("") ## local directory here

# Clear workspace

rm(list = ls())

## 1. Map A.4 Coca Production

colombia.map <- readRDS("colombia_maps.rds")

##Maps of Presence

arrowA <- data.frame(x1 = 9, x2 = 17, y1 = 14, y2 = 14.5)
arrowB <- data.frame(x1 = 9, x2 = 17, y1 = 10, y2 = 6.5)


## Create the outside layer 

survey.map = subset(colombia.map , colombia.map$aplicable==1) 
map.survey<-ggplot() + geom_sf(data = survey.map, aes(fill = trial) , size = 0.9) +scale_fill_manual(values = c("white","steelblue4", "tomato2", "red2", "red4")) + ggtitle("Treatment vs Control")+theme_void()+ theme(legend.position="bottom",legend.title = element_blank() )
map.survey

####################################################
########Check Coca Production#######################
####################################################

colombia.map$coke_2010= colombia.map$coke_2010/1000

map.coke_2010=ggplot(data = colombia.map) + geom_sf(aes(fill = coke_2010)) + ggtitle("")+ theme(legend.position="bottom") + scale_fill_gradient(low="white", high="red")+ theme(legend.title = element_blank())
siteA_coke_2010=ggplot(data = colombia.map) + geom_sf(aes(fill = coke_2010)) + geom_sf(data=survey.map, size = 1.2, aes(fill = coke_2010) , colour = "black") + ggtitle("Site A") + coord_sf(xlim = c(651829, 1002530), ylim = c(1295844, 1565844), expand =FALSE) + theme_void() + scale_fill_gradient(low="white", high="red", guide =FALSE)
siteB_coke_2010=ggplot(data = colombia.map) + geom_sf(aes(fill = coke_2010)) + geom_sf(data=survey.map, size = 1.2, aes(fill = coke_2010) , colour = "black") + ggtitle("Site B") + coord_sf(xlim = c(651829, 1052530), ylim = c(814198.2, 1195844), expand =FALSE) + theme_void() + scale_fill_gradient(low="white", high="red", guide = FALSE)
map.coke_2010

ggplot() +
  coord_equal(xlim = c(0, 28), ylim = c(0, 20), expand = FALSE) +
  annotation_custom(ggplotGrob(map.coke_2010), xmin = 0, xmax = 20, ymin = 0, 
                    ymax = 20) +
  annotation_custom(ggplotGrob(siteA_coke_2010), xmin = 18, xmax = 28, ymin = 7, 
                    ymax = 25) +
  annotation_custom(ggplotGrob(siteB_coke_2010), xmin = 18, xmax = 28, ymin = 0, 
                    ymax = 12) +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowA, 
               arrow = arrow(), lineend = "round", size=1.5) +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowB, 
               arrow = arrow(), lineend = "round", size=1.5)





