#load packages
requirements<- c("dplyr", "knitr", "rvest", "XML", "magrittr")

for(requirement in requirements){if(!(requirement %in% installed.packages()))
  install.packages(requirement)}
lapply(requirements, require, character.only=T)


#--------------------Create game log for position players-----------------------------

#Create table of players and IDs for fangraph links
player_id<-read.csv("../input/SS_position_players.csv", header=TRUE)
unique_id<-unique(player_id[,1:2]) #remove duplicate players (both teams)
position=NULL
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

#Clean up data. Create walks and strike out fields

cols<-c("BO", "PA", "H","X2B","X3B","HR","R","RBI","SB","CS", "ISO", "BABIP")
x[,cols] <- as.numeric(as.character(unlist(x[,cols])))

x$BB.<-as.numeric(gsub("%","", x$BB.))
x$K.<-as.numeric(gsub("%","", x$K.))
x$BB<-round(x$PA*x$BB./100)
x$SO<-round(x$PA*x$K./100)
position<-rbind(x,position)
                      }
}
}


#--------------------Create game log for pitchers-----------------------------

#Create table of players and IDs for fangraph links
pitcher_id<-read.csv("../input/SS_pitchers.csv", header=TRUE)
unique_pitcher<-unique(pitcher_id[,1:2]) #remove duplicate players (both teams)
pitcher=NULL
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

#Clean up data

cols<-c("IP", "H","ER", "HR","BB","SO", "BABIP")
x[,cols] <- as.numeric(as.character(unlist(x[,cols])))
pitcher<-rbind(x,pitcher)
                      }
}
}


#Pull Minor League Data
source('C:/Users/Jeff/Documents/Scoresheet Stats - Private/code/minor_game_logs.r')

Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")
rmarkdown::render("ss_analysis.Rmd", "html_document")
