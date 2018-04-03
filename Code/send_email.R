###Author: Jeff Graham
###Date: March 30, 2018 
###This file creates an HTML report of scoresheet stats and emails the results

#load packages
requirements<- c("dplyr", "knitr", "rvest", "XML", "magrittr", "mailR")

for(requirement in requirements){if(!(requirement %in% installed.packages()))
  install.packages(requirement)}
lapply(requirements, require, character.only=T)

#Create Report
source('scoresheet_logs.R')

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
                   smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "username", passwd = "password", ssl = TRUE),
                   authenticate = TRUE,
                   send = TRUE)
