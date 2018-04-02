---
title: "Scoresheet Stats"
author: "Jeff Graham"
date: "`r format(Sys.time(), '%d %B, %Y')`"
output:
  html_document:
    theme: united
    toc: yes
  pdf_document:
    toc: yes
---
  
#load packages
requirements<- c("dplyr", "knitr", "data.table")

for(requirement in requirements){if(!(requirement %in% installed.packages()))
  install.packages(requirement)}
lapply(requirements, require, character.only=T)

my_data<-read.csv("./output/position_logs.csv", header=TRUE) #read in game log data for position players
my_data$Date<-as.Date(my_data$Date) #Format date variable
j<-as.POSIXlt(Sys.Date())$wday #Count number of days after last Sunday
j<-ifelse(j == 0, 7, ifelse(j==1,8,j)) #Change Sundays to 7
my_data <- subset(my_data, my_data$Date>Sys.Date()-j) #Include only games since last Sunday


#Sum Statistics
PA<-setNames(aggregate(my_data$PA, by = list(my_data$BIS), FUN = sum),c("BIS","PA")) 
hits<-setNames(aggregate(my_data$H, by = list(my_data$BIS), FUN = sum),c("BIS","H")) 
X2B<-setNames(aggregate(my_data$X2B, by = list(my_data$BIS), FUN = sum),c("BIS","X2B"))
X3B<-setNames(aggregate(my_data$X3B, by = list(my_data$BIS), FUN = sum),c("BIS","X3B")) 
HR<-setNames(aggregate(my_data$HR, by = list(my_data$BIS), FUN = sum),c("BIS","HR"))
BB<-setNames(aggregate(my_data$BB, by = list(my_data$BIS), FUN = sum),c("BIS","BB"))
SO<-setNames(aggregate(my_data$K, by = list(my_data$BIS), FUN = sum),c("BIS","SO"))
SB<-setNames(aggregate(my_data$SB, by = list(my_data$BIS), FUN = sum),c("BIS","SB"))
CS<-setNames(aggregate(my_data$CS, by = list(my_data$BIS), FUN = sum),c("BIS","CS"))

#Merge statistics
my_data<-Reduce(function(x, y) merge(x, y, all=TRUE), list(PA, hits, X2B, X3B, HR, BB, SO, SB, CS))
#Merge with player list
player_id<-read.csv("./input/SS_position_players.csv", header=TRUE)
my_data<-merge(my_data,player_id,by = 'BIS')
my_data$OBP<-signif((my_data$H+my_data$BB)/my_data$PA,digits=3)
my_data$SLG<-signif((my_data$H-my_data$X2B-my_data$X3B-my_data$HR+2*my_data$X2B+3*my_data$X3B+4*my_data$HR)/(my_data$PA-my_data$BB),digits=3)
my_data$OPS<-(my_data$OBP+my_data$SLG)
my_data<-my_data[order(my_data$Order),] #Order by batting order
NL_my_data<-subset(my_data,League=="NL")
BL_my_data<-subset(my_data,League=="BL") 


#--------Print statistics for pitchers------------
pitcher_data<-read.csv("./output/pitcher_logs.csv", header=TRUE) #read in game log data for pitchers
pitcher_data$Date<-as.Date(pitcher_data$Date) #Format date variable
pitcher_data <- subset(pitcher_data, pitcher_data$Date>Sys.Date()-j) #Include only games since last Sunday

#Calculate corrected IP

pitcher_data$aIP<-(floor(pitcher_data$IP)+(pitcher_data$IP-floor(pitcher_data$IP))/.3)  

#Calculate weighted average BABIP
setDT(pitcher_data)
pitcher_data[, BABIP := weighted.mean(BABIP,IP), by=BIS]

#Sum Pitcher Statistics
IP<-setNames(aggregate(pitcher_data$aIP, by = list(pitcher_data$BIS), FUN = sum),c("BIS","IP"))
ER<-setNames(aggregate(pitcher_data$ER, by = list(pitcher_data$BIS), FUN = sum),c("BIS","ER"))
H<-setNames(aggregate(pitcher_data$H, by = list(pitcher_data$BIS), FUN = sum),c("BIS","H"))
HR<-setNames(aggregate(pitcher_data$HR, by = list(pitcher_data$BIS), FUN = sum),c("BIS","HR"))
SO<-setNames(aggregate(pitcher_data$SO, by = list(pitcher_data$BIS), FUN = sum),c("BIS","SO"))
BB<-setNames(aggregate(pitcher_data$BB, by = list(pitcher_data$BIS), FUN = sum),c("BIS","BB"))
BABIP<-setNames(aggregate(pitcher_data$BABIP, by = list(pitcher_data$BIS), FUN = mean),c("BIS","BABIP"))

#Merge pitcher statistics
pitcher_data<-Reduce(function(x, y) merge(x, y, all=TRUE), list(IP, ER, H, HR, SO, BB, BABIP))

#Add more stats
pitcher_data$WHIP<-signif((pitcher_data$BB+pitcher_data$H)/pitcher_data$IP,digits=2)
pitcher_data$ERA<-signif((pitcher_data$ER*9)/pitcher_data$IP,digits=3)
pitcher_data$IP<-signif((floor(pitcher_data$IP)+(pitcher_data$IP-floor(pitcher_data$IP))/3.3),digits=2)
#pitcher_data$aIP<-(floor(pitcher_data$IP)+(pitcher_data$IP-floor(pitcher_data$IP))/.3)  
pitcher_data$BABIP<-signif(pitcher_data$BABIP,digits=3)

#Merge with player list
pitcher_id<-read.csv("./input/SS_pitchers.csv", header=TRUE)
pitcher_data<-merge(pitcher_data,pitcher_id,by = 'BIS') 
pitcher_data<-pitcher_data[order(pitcher_data$Order),]

NL_pitcher_data<-subset(pitcher_data,League=="NL")
BL_pitcher_data<-subset(pitcher_data,League=="BL")

NL_my_data<-NL_my_data[,c("Name","Order","PA","H", "X2B","X3B","HR","BB","SO","SB","CS","OBP","SLG","OPS")]
kable(NL_my_data, caption = 'NL-332 Position Player Summary', row.names = FALSE)
 
NL_pitcher_data<-NL_pitcher_data[,c("Name","Order","IP", "ER","H","HR","BB","SO","BABIP","ERA","WHIP")]
kable(NL_pitcher_data, caption = 'NL-332 Pitcher Summary', row.names = FALSE)

BL_my_data<-BL_my_data[,c("Name","Order","PA","H", "X2B","X3B","HR","BB","SO","SB","CS","OBP","SLG","OPS")]
kable(BL_my_data, caption = 'BL-Jordan Position Player Summary',row.names = FALSE)

BL_pitcher_data<-BL_pitcher_data[,c("Name","Order","IP", "ER","H","HR","BB","SO","BABIP","ERA","WHIP")]
kable(BL_pitcher_data, caption = 'BL-Jordan Pitcher Summary', row.names = FALSE)


