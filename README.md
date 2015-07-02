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
* 

### Main Scripts
You need to have 2 main scripts before any of the others will work.

The main script is Resource.ps1.  This is the script where, as the project continues I will be moving most of the functions.  I am working on other files to do specific jobs and if possible I will move the code from these files into the Resource.ps1 file as functions.

The other file you need to have is config.json which contains  the "config" data for your environment, like the MySql server ip address, db name, db user, db password, and last but most importantly, your integration key.

At some point I will update this to use the oAuth token process but integration key is fine to get the project going.

#### Additional Scripts

* changeWatch.ps1
** This is a script 

###### More DC-Ess/EchoSign Dev related info can be found here: 
https://www.evernote.com/l/AgU23YnN4rtJCJRWir6DebRuzq-sNU-qKbc


