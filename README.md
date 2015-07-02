## DC-ESS/EchoSign-InfoGatherer
A set of PowerShell scripts that work with a MySql Database Server to gather all Adobe Document Cloud - eSign Services(Formerly EchoSign) data for your account.

This is a set of scripts that I have been working on for a while that will process data gathered via REST calls against the "Adobe Document Cloud - eSign Services" REST API.

Currently this requires a windows server or workstation running PowerShell 4.0 and a MySql 5.5.32 databse server.

I started this project because I wanted to give my customers a good way to collect all the ESS related data so they could run their own reports.

Eventually I will probably add some BIRT report files to this repo so folks can use those for "common" reports, and get some ideas about other reports they might like to create.  I'm trying to make this as easy on myself as possible and I am fairly familiar with PowerShell which also has easy ways of consuming REST data so for me this was my "way to go"

I just started working on this a few weeks ago in my "spare" time so the going is slow.

If you would like to contribute please feel free to email me or make the request via Git.

### Requirements:
Requirements so far:

* Windows Machine 
* PowerShell 4.0
* MySql "Community" 5.5.32
* MySql  Net Connector 6.9.6

### Main Scripts
You need to have 2 main scripts before any of the others will work. Please keep them both, along with any other scripts I add to the project or that you might create in the same folder as I assume that all the scripts are being run from one directory.

The main script is Resource.ps1.  This is the script where, as the project continues I will be moving most of the functions.  I am working on other files to do specific jobs and if possible I will move the code from these files into the Resource.ps1 file as functions.  This script should be "included" at the top of other scripts where you want to use the functions there.  See the 1st 3 lines in my other scripts to see how to do this "include" with powershell. 

The other file you need to have is config.json which contains  the "config" data for your environment, like the MySql server ip address, db name, db user, db password, and last but most importantly, your integration key.

At some point I will update this to use the oAuth token process but integration key is fine to get the project going.

#### Additional Scripts

1. changeWatch.ps1

  * This is a script that when started goes into an "endless loop" and watches the "tmp_agreements" table fo new inserts to process via the "getAgreementInfo" function in the Resource.ps1 file to gather and update the database with all the info available in the "[getAgreementInfo](https://secure.echosign.com/public/docs/restapi/v3#!/agreements/_0_1)" REST call. When it finds new non-processed records it will process them up tp 200 at a time.  It will update the agreements, events, and recipients tables for each set of data it retrieves for each agreement ID/Docunment Key it finds in the tmp_agreements table.

2. GetUsers.ps1
 
  * This script will get all the users in your account and save them to the users table. After it gets the data in the rest call it also exprts all the data to a .csv file it creates in a "/users" subfolder in the directory where the script is being run.

3. dc_ess_data_create.sql

  * This is the script used to create the MySql database.  Again, as I get into dealing with form data where there will be a variable number of columns for each agreements with different names to match the field names, I will probably eventually change the entire project over to use a "NoSql" type db like Apache Cassandra, but for now since I am fairly familiar with MySql I have started there.

4. RunChangeWatchers.bat and RunChangeWatchers_visible.bat
  * These are just a way to copy and start the "changeWatcher" scripts. I typically have about 5 running at once but you can adjust as you need and start more or fewer depending on your server configuration and your load/volumne of agreements that need to be processed. In my experience with one script running the collection of the agreements IDs for a very heavy user, you can process about 20K agreements for their "status" data in about 80-90 mins.  I have run through this many times in testing with a single user for which I had to collect all ESS data for from over a 2 year span.



###### More DC-Ess/EchoSign Dev related info can be found here: 
https://www.evernote.com/l/AgU23YnN4rtJCJRWir6DebRuzq-sNU-qKbc


