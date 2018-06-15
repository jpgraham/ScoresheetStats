
#Create table of players and IDs for fangraph links
player_id<-read.csv("../input/SS_minors.csv", header=TRUE)
minor_position=NULL
#Scrape position player data and combine into a single file
for (i in player_id[,2]) {
test=try(read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i
                         ,"&position=",player_id[match(i,player_id$BIS_Number),4],"&type=-1&gds=&gde=","&season=2018",sep="",collapse=NULL)),TRUE)
if(class(test)!= "try-error"){  
x<-read_html(paste("http://www.fangraphs.com/statsd.aspx?playerid=",i
,"&position=",player_id[match(i,player_id$BIS_Number),4],"&type=-1&gds=&gde=","&season=2018",sep="",collapse=NULL))
x<-x %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x),(data.frame(x)$Date=="Total"))#converts to a data frame and only keeps season totals
x$Name<-as.character(player_id[match(i,player_id$BIS_Number),1]) #Add name variable from player list
x$League<-as.character(player_id[match(i,player_id$BIS_Number),3]) #Add league from player list

#Clean up data.

cols<-c("AB", "PA", "H","X2B","X3B","HR","R", "SF", "SH", "BB", "IBB", "HBP", "SO", "RBI","SB","CS", "AVG")
x[,cols] <- as.numeric(as.character(unlist(x[,cols])))

x$"BB%"<-as.numeric(round(100*x$BB/x$PA,digits=1))
x$"SO%"<-as.numeric(round(100*x$SO/x$PA,digits=1))
x$OBP<-as.numeric(signif((x$H+x$BB+x$HBP)/(x$AB+x$BB+x$HBP+x$SF+x$SH),digits=3))
x$SLG<-as.numeric(signif((x$H-x$X2B-x$X3B-x$HR+2*x$X2B+3*x$X3B+4*x$HR)/x$AB,digits=3))
x$OPS<-(x$OBP+x$SLG)
minor_position<-rbind(x,minor_position)
                      }
}
}

#Sort by SLG%
minor_position<-minor_position[order(-minor_position$OPS),]

#Create table of players and IDs for fangraph links
pitcher_id<-read.csv("../input/SS_minor_pitchers.csv", header=TRUE)
minor_pitcher=NULL
#Scrape position player data and combine into a single file
for (i in pitcher_id[,2]) {
test=try(read_html(paste("https://www.fangraphs.com/statsd.aspx?playerid=", i, "&position=P&type=-1&gds=&gde=&season=2018",sep="",collapse=NULL)),TRUE)
if(class(test)!= "try-error"){
x<-read_html(paste("https://www.fangraphs.com/statsd.aspx?playerid=", i, "&position=P&type=-1&gds=&gde=&season=2018",sep="",collapse=NULL))
x<-x %>%
  html_nodes("#DailyStats1_dgSeason1_ctl00")%>%html_table(header=NA, )
if(length(x) != 0) { 
x<-subset(data.frame(x),(data.frame(x)$Date=="Total"))#converts to a data frame and only keeps season totals
x$Name<-as.character(pitcher_id[match(i,pitcher_id$BIS_Number),1]) #Add name variable from player list
x$League<-as.character(pitcher_id[match(i,pitcher_id$BIS_Number),3]) #Add league from player list

#Clean up data
cols<-c("IP", "GS", "TBF", "H", "HR","BB", "HBP", "SO", "ERA")
x[,cols] <- as.numeric(as.character(unlist(x[,cols])))

x$AVG<-as.numeric(round(x$H/(x$TBF-x$BB-x$HBP),digits=3))
x$BABIP<-as.numeric(round((x$H-x$HR)/(x$TBF-x$BB-x$HBP-x$SO-x$HR),digits=3)) #Approximation:does not include in sacrifices
x$WHIP<-as.numeric(round((x$H+x$BB)/x$IP,digits=2))
x$"BB%"<-as.numeric(round(100*x$BB/x$TBF,digits=1))
x$"SO%"<-as.numeric(round(100*x$SO/x$TBF,digits=1))

minor_pitcher<-rbind(x,minor_pitcher)
                      }
}
}

#Sort by League
minor_pitcher<-minor_pitcher[order(minor_pitcher$AVG),]
