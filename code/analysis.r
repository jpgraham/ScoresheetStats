library(plyr)
library(YaleToolkit)
setwd('C:/Users/Jeff/Documents/ScoreSheet Stats')
my_data<-read.csv("./output/game_logs.csv", header=TRUE) #read in game log data
my_data$Date<-as.Date(my_data$Date) #Format date variable
#printmy_data<-subset(my_data,my_data$Date>="2017-04-01") # Remove games from April 
my_data$is_hit<-as.numeric(my_data$H>0)
my_data<-ddply(my_data,.(Name), mutate, lag_is_hit = c(NA, head(is_hit, -1)),lag_hit = c(NA, head(H, -1)))
#mylogit <- glm(is_hit ~ BO + PA + BB + lag_hit + factor(Name)-1, data = my_data, family = "binomial")
#print(summary(mylogit))
#mylinear<-lm(is_hit ~ BO + PA + BB + lag_hit + factor(Name)-1, data = my_data)
#print(summary(mylinear))
x<-setNames(aggregate(my_data$is_hit, by = list(my_data$Name), FUN = mean),c("Player","Avg_Hits"))
x <- x[order(-x$Avg_Hits),]
x$Avg_Hits<-signif(x$Avg_Hits, digits=4)
y<-setNames(aggregate(my_data$BO, by = list(my_data$Name), FUN = mean),c("Player","Avg_BO"))
y <- y[order(-y$Avg_BO),]
y$Avg_BO<-signif(y$Avg_BO, digits=2)
z<-setNames(aggregate(my_data$PA, by = list(my_data$Name), FUN = sum),c("Player","PA"))
z <- z[order(-z$PA),]
z<-subset(z,z$PA>50) # Remove players with less than 50 PA 
#print(head(y, n=25))
#print(head(z, n=10))
 
#Calculate average last 10 games

last_ten <- subset(my_data, my_data$Date>Sys.Date()-10)
a<-setNames(aggregate(last_ten$PA, by = list(last_ten$Name), FUN = sum),c("Player","Total_PA"))
b<-setNames(aggregate(last_ten$H, by = list(last_ten$Name), FUN = sum),c("Player","Total_H"))
c<-setNames(aggregate(last_ten$BB, by = list(last_ten$Name), FUN = sum),c("Player","Total_BB"))
ab<-merge(a,b,by="Player")
abc<-merge(ab,c,by="Player")
abc$AvgLast10<-signif(abc$Total_H/(abc$Total_PA-abc$Total_BB), digits=3)
abc<-subset(abc,abc$AvgLast10>.250) # Remove players with average less .250 over last 10 
abc<-subset(abc, select=-c(Total_PA, Total_H, Total_BB))
 
xy<-merge(x,y,by="Player")
xyz<-merge(xy,z,by="Player")
xyz<-merge(xyz,abc, by="Player")
xyz<-xyz[order(-xyz$Avg_Hits),]

#Calculate Home vs. Away Averages
my_data$away<-substr(my_data$Opp,1,1)
my_data$away<-ifelse(my_data$away=="@",'Away','Home')
away<-setNames(aggregate(my_data$is_hit, by = list(my_data$away), FUN = mean),c("Split","Avg_Hits"))
away <- away[order(-away$Avg_Hits),]
away$Avg_Hits<-signif(away$Avg_Hits, digits=4)

print('Top hitters')
print(head(xyz, n=20))

t<-setNames(aggregate(my_data$is_hit, by = list(my_data$Opp), FUN = mean),c("Team","Avg_Hits"))
t <- t[order(-t$Avg_Hits),]
t$Avg_Hits<-signif(t$Avg_Hits, digits=4)
print('Top teams')
print(head(t,n=5))

print('Home vs. Away')
print(away)
