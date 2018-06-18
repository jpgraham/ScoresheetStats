# Scoresheet Stats
This project is designed to pull MLB player game logs from fangraphs.com and create a daily email report. The report contains stats for a predetermined set of players for the current week. The schedule is desinged around a typical Scoresheet schedule of Monday - Sunday. 
# Getting Started
All code is run in R which can be found here:
```
https://www.r-project.org/
```
The R-Markdown file may require LateX installation. MikTex what I use and can be found here:
```
https://miktex.org/download
```
Indiviudal scripts may require the installation of additional R packages. If needed, the installtion code is provided in the scripts.

## Instructions

1.```send_emal.R``` is the main script and can be run seperately. It creates the report summary file ```ss_analysis.html``` report and emails it to set of recpients. ```Email_Report.bat``` is also provided to run this script as a batch file.
2.```send_email.R``` calls the scripts ```scoresheet_log.R```,  ```minor_game_logs.R```, and  ```ss_analysis.Rmd```. The respective function of these scripts is to pull the major league player data, pull minor league player data, and create the html report. 

## Input Data
There are four input files that contain the player name, Fangraph (BIS) ID numbers, order, team league, and (optional) position. There are seperate files for major/minor league position players and major/minor league pitchers. No modification is required but they can be updated to collect data on different players. The file must contain the player name and the Fangraph ID number for each player you wish to collect stats on. The ID number can be found in the Fangraphs player page URL or can be found in ```SFBB_Plaer-ID-map``` (IDFANGRAPHS). If a minor league player has had major league time, the position field must be filled in to pull the correct data.

## Authors

* **Jeff Graham**

## Acknowledgements

Database of player IDs was provided by ```https://www.smartfantasybaseball.com```
