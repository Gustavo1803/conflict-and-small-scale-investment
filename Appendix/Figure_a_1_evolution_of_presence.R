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

## 1. Figure A.1 Evolution of Presence (2010 - 2016)

datapresence<-read.csv("presence.csv",header = TRUE)
datapresence<-as.data.frame(datapresence)

datapresence = datapresence %>% mutate(t = ifelse(year<2014,"a","b"))

presence<-ggplot(datapresence, aes(x=year, y=presence, color=t)) + geom_point(size =3)  + geom_smooth(method=lm, se =FALSE) +
  theme(axis.text.x = element_text(size = 20), axis.text.y = element_text(size = 20), plot.title = element_text(color="black", size=20, face="bold.italic"),axis.title.x=element_text(size=7),axis.title.y=element_text(size=20) ,legend.title = element_text(size = 32), legend.text = element_text(size = 32)) +
  scale_y_continuous(n.breaks = 10, limits = c(0,6) ) + scale_x_continuous(limits = c(2010,2016),n.breaks = 6) + labs(x="Year", y="Presence") 
presence<-presence + scale_color_discrete(name = "Period", labels = c("Pre-Ceasefire","Post-Ceasefire"))  + geom_vline(xintercept = 2013.5, linetype="dotted", color = "black", size=1.5) + theme_bw(base_size = 18)


presence +geom_line(aes(y=lower.bond), linetype = "dotted", size =2) +
  geom_line(aes(y=higher.bond), linetype = "dotted", size =2) 

