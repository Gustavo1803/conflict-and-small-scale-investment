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

## 1. Map A.1 Location of the Villages

colombia.map <- readRDS("colombia_maps.rds")

##Maps of Presence

arrowA <- data.frame(x1 = 9, x2 = 17, y1 = 14, y2 = 14.5)
arrowB <- data.frame(x1 = 9, x2 = 17, y1 = 10, y2 = 6.5)


## Create the outside layer 

survey.map = subset(colombia.map , colombia.map$aplicable==1) 
map.survey<-ggplot() + geom_sf(data = survey.map, aes(fill = trial) , size = 0.9) +scale_fill_manual(values = c("white","steelblue4", "tomato2", "red2", "red4")) + ggtitle("Treatment vs Control")+theme_void()+ theme(legend.position="bottom",legend.title = element_blank() )
map.survey

##Map of Treatment and Control

map.2010<-ggplot(data = colombia.map) + geom_sf(aes(fill = trial)) +scale_fill_manual(values = c("white", "#FFDB6D","steelblue4", "tomato2", "red2", "red4")) + ggtitle("Treatment vs Control")+theme_void()+ theme(legend.position="bottom",legend.title = element_blank() )
siteA<-ggplot(data = colombia.map) + geom_sf(aes(fill = trial)) +scale_fill_manual(values = c("white", "#FFDB6D","steelblue4", "tomato2", "red2", "red4"), guide=FALSE) + ggtitle("Site A") + coord_sf(xlim = c(651829, 1002530), ylim = c(1295844, 1565844), expand =FALSE) + theme_void()
siteB<-ggplot(data = colombia.map) + geom_sf(aes(fill = trial)) +scale_fill_manual(values = c("white", "#FFDB6D","steelblue4", "tomato2", "red2", "red4"), guide=FALSE) + ggtitle("Site B") + coord_sf(xlim = c(651829, 1052530), ylim = c(814198.2, 1195844), expand =FALSE) + theme_void()
map.2010

ggplot() +
  coord_equal(xlim = c(0, 28), ylim = c(0, 20), expand = FALSE) +
  annotation_custom(ggplotGrob(map.2010), xmin = 0, xmax = 20, ymin = 0, 
                    ymax = 20) +
  annotation_custom(ggplotGrob(siteA), xmin = 18, xmax = 28, ymin = 7, 
                    ymax = 25) +
  annotation_custom(ggplotGrob(siteB), xmin = 18, xmax = 28, ymin = 0, 
                    ymax = 12) +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowA, 
               arrow = arrow(), lineend = "round", size=1.5) +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowB, 
               arrow = arrow(), lineend = "round", size=1.5)