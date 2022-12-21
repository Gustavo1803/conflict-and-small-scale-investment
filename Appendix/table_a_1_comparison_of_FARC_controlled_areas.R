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

######### 1.Table A.1 Comparison of FARC controlled Areas ########

violence = read_rds('violence.rds')
general_charact = read_rds('general_characteristics.rds')

## Camparing Sample of Controlled Areas with Sample of Population--------------------------------

table1 = violence %>% group_by(prov, presence) %>% summarise(m_rate = mean(m_rate),
                                                                 c_rate = mean(c_rate), 
                                                                 m_rate_eln = mean(m_rate_eln),
                                                                 c_rate_eln = mean(c_rate_eln)) %>%
  mutate(vio = m_rate + c_rate,
         vio_eln = m_rate_eln + c_rate_eln,
         high= ifelse(vio>0.0,1,0),
         high_eln= ifelse(vio_eln>0.0,1,0)) %>% arrange(desc(c_rate)) 

tab1 = as.data.frame(table1) %>% group_by(presence) %>% summarise(vio_mean = mean(vio)*10,
                                                                  vio_sd = sd(vio)*10) %>% filter(presence==1) %>% dplyr::select(-presence)

tab2 = as.data.frame(table1) %>% group_by(high) %>% summarise(vio_mean = mean(vio)*10,
                                                              vio_sd = sd(vio)*10) %>% filter(high==1) %>% dplyr::select(-high)

tab1_eln = as.data.frame(table1) %>% group_by(presence) %>% summarise(vio_mean_eln = mean(vio_eln)*10,
                                                                      vio_sd_eln = sd(vio_eln)*10) %>% filter(presence==1) %>% dplyr::select(-presence)

tab2_eln = as.data.frame(table1) %>% group_by(high) %>% summarise(vio_mean_eln = mean(vio_eln)*10,
                                                                  vio_sd_eln = sd(vio_eln)*10) %>% filter(high==1) %>% dplyr::select(-high)

## Analysis for other Tables ---------------------------------------------------


tab_t1 = as.data.frame(general_charact) %>% group_by(presence) %>% summarise(gdp_per_mean  = mean(gdp_per),
                                                                            gdp_per_sd    = sd(gdp_per),
                                                                            gdp_ag_per_mean = mean(gdp_ag_per),
                                                                            gdp_ag_per_sd = sd(gdp_ag_per),
                                                                            poverty2_mean = mean(poverty2),
                                                                            poverty_sd    = sd(poverty2)) %>% 
                                                                            filter(presence==1) %>% dplyr::select(-presence) 

tab_t2 = as.data.frame(general_charact) %>% group_by(high) %>% summarise(gdp_per_mean  = mean(gdp_per),
                                                                         gdp_per_sd    = sd(gdp_per),
                                                                         gdp_ag_per_mean = mean(gdp_ag_per),
                                                                         gdp_ag_per_sd = sd(gdp_ag_per),
                                                                         poverty2_mean = mean(poverty2),
                                                                         poverty_sd    = sd(poverty2)) %>% filter(high==1) %>% dplyr::select(-high)

tab1   =  t(tab1)
tab1_eln = t(tab1_eln)
tab_t1 = t(tab_t1)

tab2   =  t(tab2)
tab2_eln = t(tab2_eln)
tab_t2 = t(tab_t2)

Elca = rbind(tab1,tab1_eln,tab_t1)
population = rbind(tab2,tab2_eln,tab_t2)


### Table A.1 Comparison of FARC controlled Areas #####

table_a1 = cbind(Elca, population)

### Regression on Region ###
reg1 = lm(high~presence + 0, data = table1)
summary(reg1)



