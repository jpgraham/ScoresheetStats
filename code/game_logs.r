library(rvest)
library(XML)
setwd('C:/Users/Jeff/Documents/ScoreSheet Stats')

#Create table of players and IDs for fangraph links
player_id<-read.csv("./input/BIS_numbers.csv", header=TRUE)
my_data=NULL
#Scrape data and combine into a single file
for (i in player_id[,4]) {
x<-html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i,"&season=2017",sep="",collapse=NULL))
x<-x %>%
  html_nodes(".rgMasterTable")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x), !(data.frame(x)$Date=="Date" | data.frame(x)$Date=="Total"))#converts to a data frame and drops duplicate headers and season totals
x$Name<-as.character(player_id[match(i,player_id$BIS_Number),3]) #Add name variable from player list
x$BO<-as.numeric(x$BO)
x$PA<-as.numeric(x$PA)
x$H<-as.numeric(x$H)
x$X2B<-as.numeric(x$X2B)
x$X3B<-as.numeric(x$X3B)
x$HR<-as.numeric(x$HR)
x$R<-as.numeric(x$R)
x$RBI<-as.numeric(x$RBI)
x$SB<-as.numeric(x$SB)
x$CS<-as.numeric(x$CS)
x$BB.<-as.numeric(gsub("%","", x$BB.))
x$K.<-as.numeric(gsub("%","", x$K.))
x$ISO<-as.numeric(x$ISO)
x$BABIP<-as.numeric(x$BABIP)
x$BB<-round(x$PA*x$BB./100)
x$K<-round(x$PA*x$K./100)
my_data<-rbind(x,my_data)
Sys.sleep(1) #Pause to avoid overloading fangraph server 
                      }
}
write.csv(my_data, "./output/game_logs.csv", row.names=FALSE) #Export data to csv file
source("analysis.r")
