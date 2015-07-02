# include resource file
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory Resource.ps1)
# Kills $StartStopArray and runs getStartStopArray
#Remove-Variable StartStopArray -Force


# Set Start time(how far back you need to gather all info for)
$startHt = [datetime]"02-06-2014"
# create query to get user info from users table
$userInfoQ = "Select * from users where email = 'yourUser@yourDomain.com';"
# run query to get info into object
$info = runquery $userInfoQ

# run function to gather all agreements for this user from the start date by
# using the "event search" REST for one week at a time.
getHistoryFor1User $startHt $info.email $info.userId

   