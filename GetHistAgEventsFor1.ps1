# include resource file
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory Resource.ps1)
# Kills $StartStopArray and runs getStartStopArray
#Remove-Variable StartStopArray -Force



$startHt = [datetime]"02-06-2014"

$email1 = "yourUser@yourdomain.com"

$userId1 = "This users id from the user table after running the GetUsers script"
            
getHistoryFor1User $startHt $email1 $userId1

   