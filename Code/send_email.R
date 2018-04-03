###Author: Jeff Graham
###Date: March 30, 2018 
###This file creates an HTML report of scoresheet stats and emails the results

#Create Report
source('C:/Users/Jeff/Documents/Scoresheet Stats/scoresheet_logs.R')
library(mailR)
#send email
date<-format(Sys.Date(), format="%B %d %Y")
sender <- "sender@gmail.com" # Replace with a valid address
recipients <- c("recipient@gmail.com") # Replace with one or more valid addresses
email <- send.mail(from = sender,
                   to = recipients,
                   subject=paste("Scoresheet Stats as of",date),
                   body = paste("Weekly results as of",date),
                   attach.files = c("ss_analysis.html"),
                   html = TRUE,
                   inline = TRUE,
                   smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "sender", passwd = "passwd", ssl = TRUE),
                   authenticate = TRUE,
                   send = TRUE)
