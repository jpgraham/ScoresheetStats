# Scoresheet Stats
This project is designed to pull MLB player game logs from fangraphs.com and create a daily email report. The report contains stats for a predetermined set of players for the current week. The schedule is desinged around a typical Scoresheet schedule of Monday - Sunday. 
# Getting Started
All code in run in R which can be found here:
```
https://www.r-project.org/
```
The R-Markdown file may require LateX installation. MikTex what I use and can be found here:
```
https://miktex.org/download
```
Indiviudal scripts may require the installation of additional R packages. If needed, the installtion code will be provide in the script.
## Instructions

1.```send_emal.R``` creates the ```ss_analysis.html``` report and emails it to set of recpients. ```Email_Report.bat``` runs this script as a batch file.
2.```send_email.R``` calls the script ```scoresheet_log.R``` which pulls the player data from Fangraphs.com. The list of players is contained in 4 seperate .csv files. These files must contain the player name and BIS number for each player. 

## Authors

* **Jeff Graham**
