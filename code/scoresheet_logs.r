#load packages
requirements<- c("dplyr", "knitr", "rvest", "XML", "magrittr")

for(requirement in requirements){if(!(requirement %in% installed.packages()))
  install.packages(requirement)}
lapply(requirements, require, character.only=T)


#--------------------Create game log for position players-----------------------------
#Create table of players and IDs for fangraph links
player_id<-read.csv("../input/SS_position_players.csv", header=TRUE)
unique_id<-unique(player_id[,1:2]) #remove duplicate players (both teams)
my_data=NULL
#Scrape data and combine into a single file
for (i in unique_id[,2]) {
test=try(read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i,"&season=2018",sep="",collapse=NULL)),TRUE)
if(class(test)!= "try-error"){
x<-read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i,"&season=2018",sep="",collapse=NULL))
x<-x %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x), !(data.frame(x)$Date=="Date" | data.frame(x)$Date=="Total"))#converts to a data frame and drops duplicate headers and season totals
x$BIS<-as.numeric(unique_id[match(i,unique_id$BIS),2]) #Add BIS Number from player list
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
                      }
}
}
write.csv(my_data, "../output/position_logs.csv", row.names=FALSE) #Export data to csv file



#--------------------Create game log for pitchers players-----------------------------
#Create table of players and IDs for fangraph links
pitcher_id<-read.csv("../input/SS_pitchers.csv", header=TRUE)
unique_pitcher<-unique(pitcher_id[,1:2]) #remove duplicate players (both teams)
my_data=NULL
#Scrape data and combine into a single file
for (i in unique_pitcher[,2]) {
test=try(read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i,"&season=2018",sep="",collapse=NULL)),TRUE)
if(class(test)!= "try-error"){  
x<-read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i,"&season=2018",sep="",collapse=NULL))
x<-x %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x), !(data.frame(x)$Date=="Date" | data.frame(x)$Date=="Total"))#converts to a data frame and drops duplicate headers and season totals
x$BIS<-as.numeric(unique_pitcher[match(i,unique_pitcher$BIS),2]) #Add BIS Number order from player list
x$IP<-as.numeric(x$IP)
x$H<-as.numeric(x$H)
x$ER<-as.numeric(x$ER)
x$HR<-as.numeric(x$HR)
x$BB<-as.numeric(x$BB)
x$SO<-as.numeric(x$SO)
x$BABIP<-as.numeric(x$BABIP)
my_data<-rbind(x,my_data)
                      }
}
}
write.csv(my_data, "../output/pitcher_logs.csv", row.names=FALSE) #Export data to csv file

#Minor League Data
source('minor_game_logs.r')

Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")
rmarkdown::render("ss_analysis.Rmd", "html_document")