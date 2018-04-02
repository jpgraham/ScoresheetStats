library(rvest)
library(XML)

setwd('C:/Users/Jeff/Documents/Scoresheet Stats')

#Create table of players and IDs for fangraph links
player_id<-read.csv("./input/SS_minors.csv", header=TRUE)
my_data=NULL
#Scrape position player data and combine into a single file
for (i in player_id[,2]) {
x<-read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i
,"&position=",player_id[match(i,player_id$BIS_Number),4],"&type=-1&gds=&gde=","&season=2017",sep="",collapse=NULL))
x<-x %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x),(data.frame(x)$Date=="Total"))#converts to a data frame and only keeps season totals
x$Name<-as.character(player_id[match(i,player_id$BIS_Number),1]) #Add name variable from player list
x$League<-as.character(player_id[match(i,player_id$BIS_Number),3]) #Add league from player list
x$AB<-as.numeric(x$AB)
x$PA<-as.numeric(x$PA)
x$H<-as.numeric(x$H)
x$X2B<-as.numeric(x$X2B)
x$X3B<-as.numeric(x$X3B)
x$HR<-as.numeric(x$HR)
x$R<-as.numeric(x$R)
x$SF<-as.numeric(x$SF)
x$SH<-as.numeric(x$SH)
x$BB<-as.numeric(x$BB)
x$IBB<-as.numeric(x$IBB)
x$HBP<-as.numeric(x$HBP)
x$"BB%"<-as.numeric(round(100*x$BB/x$AB),digits=1)
x$SO<-as.numeric(x$SO)
x$"SO%"<-as.numeric(round(100*x$SO/x$AB),digits=1)
x$RBI<-as.numeric(x$RBI)
x$SB<-as.numeric(x$SB)
x$CS<-as.numeric(x$CS)
#x$BABIP<-as.numeric(x$BABIP)
x$AVG<-as.numeric(x$AVG)
#x$SLG<-as.numeric(x$SLG)
x$OBP<-as.numeric(signif((x$H+x$BB+x$HBP)/(x$AB+x$BB+x$HBP+x$SF+x$SH),digits=3))
x$SLG<-as.numeric(signif((x$H-x$X2B-x$X3B-x$HR+2*x$X2B+3*x$X3B+4*x$HR)/x$AB,digits=3))
x$OPS<-(x$OBP+x$SLG)
#x$BB.<-as.numeric(gsub("%","", x$BB.))
#x$K.<-as.numeric(gsub("%","", x$K.))
#x$ISO<-as.numeric(x$ISO)
#x$BABIP<-as.numeric(x$BABIP)
#x$BB<-round(x$PA*x$BB./100)
#x$K<-round(x$PA*x$K./100)
my_data<-rbind(x,my_data)
                      }
}

#Sort by SLG%
ML_my_data<-my_data[order(-my_data$OPS),]
write.csv(ML_my_data, "./output/ML_position_logs.csv", row.names=FALSE) #Export data to csv file

#Create table of players and IDs for fangraph links
pitcher_id<-read.csv("./input/SS_minor_pitchers.csv", header=TRUE)
pitcher_data=NULL
#Scrape position player data and combine into a single file
for (i in pitcher_id[,2]) {
y<-read_html(paste("https://www.fangraphs.com/statsd.aspx?playerid=", i, "&position=P&type=-1&gds=&gde=&season=",sep="",collapse=NULL))
y<-y %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(y) != 0) { 
y<-subset(data.frame(y),(data.frame(y)$Date=="Total"))#converts to a data frame and only keeps season totals
y$Name<-as.character(pitcher_id[match(i,pitcher_id$BIS_Number),1]) #Add name variable from player list
y$League<-as.character(pitcher_id[match(i,pitcher_id$BIS_Number),3]) #Add league from player list
y$IP<-as.numeric(y$IP)
y$GS<-as.numeric(y$GS)
y$TBF<-as.numeric(y$TBF)
y$H<-as.numeric(y$H)
y$HR<-as.numeric(y$HR)
y$BB<-as.numeric(y$BB)
y$HBP<-as.numeric(y$HBP)
y$SO<-as.numeric(y$SO)
y$ERA<-as.numeric(y$ERA)
y$AVG<-as.numeric(round(y$H/(y$TBF-y$BB-y$HBP),digits=3))
y$BABIP<-as.numeric(round((y$H-y$HR)/(y$TBF-y$BB-y$HBP-y$SO-y$HR),digits=3)) #Approximation:does not include in sacrifices
y$WHIP<-as.numeric(round((y$H+y$BB)/y$IP,digits=2))
y$"BB%"<-as.numeric(round(100*y$BB/y$TBF,digits=1))
y$"SO%"<-as.numeric(round(100*y$SO/y$TBF,digits=1))

pitcher_data<-rbind(y,pitcher_data)
                      }
}

#Sort by League
ML_pitcher_data<-pitcher_data[order(pitcher_data$AVG),]
write.csv(ML_pitcher_data, "./output/ML_pitcher_logs.csv", row.names=FALSE) #Export data to csv file

