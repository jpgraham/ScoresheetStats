library(rvest)
library(XML)

#Create table of players and fangraph links
players<-c("Joe Panik", "Paul Goldschmidt", "Adrain Beltre")
links<-c("http://www.fangraphs.com/statsd.aspx?playerid=11936&position=2B",
		 "http://www.fangraphs.com/statsd.aspx?playerid=9218&position=1B",
		 "http://www.fangraphs.com/statsd.aspx?playerid=639&position=3B")
pl<-data.frame(players,links)
my_data=NULL

#Scrape data and combine into a single file
for (i in pl[,2]) {
x<-html(i)
x<-x %>%
  html_nodes(".rgMasterTable")%>%html_table(header=NA, )
x<-subset(data.frame(x), !(data.frame(x)$Date=="Date" | data.frame(x)$Date=="Total"))#converts to a data frame and drops duplicate headers and season totals
x$Name<-as.character(pl[match(i,pl$links),1]) #Add name variable from player list


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
write.csv(my_data, "./output/game_log.csv", row.names=FALSE) #Export data to csv file