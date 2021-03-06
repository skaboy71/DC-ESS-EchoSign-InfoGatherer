$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory Resource.ps1)

$clearUsersQ = "truncate table users"
runquery $clearUsersQ 

# get users from REST into object
$users = Invoke-RestMethod -Method Get -Uri $userRec -Header @{ "Access-Token" = $apiKey }
# clean list
$global:userList = $users.userInfoList
# set path to save csv for current list of users
$usersPath = "./users"
# create path if not found
if (!(Test-Path $usersPath)){mkdir $usersPath}
# export user list to csv
$userList | export-csv -path ./users/userList.csv -force -NoTypeInformation
# load user list to "users" table in DB
foreach($user IN $userList)
    {
           $squery = "INSERT INTO users (company, email, fullName, groupId, userId) VALUES ('"+ $user.company +"', '"+ $user.email +"', '"+ $user.fullNameOrEmail + "', '" + $user.groupId + "', '" + $user.userId + "') ON DUPLICATE KEY UPDATE userId = '" + $user.userId +"'" 
           # $query
           runquery($squery)

           $userInfoRec = $userRec +"/"+$user.userId

           $userInfo = Invoke-RestMethod -Method Get -Uri $userInfoRec -Header @{ "Access-Token" = $apiKey }

           $roles = $userInfo.roles -join ","

           $capabilities = $userInfo.capabilityFlags -join ","

           $nquery = "UPDATE users SET lastName = '" + $userInfo.lastName + `
           "', firstName = '" + $userInfo.firstName + `
           "', capabilities = '" + $capabilities + `
           "', accountType =  '" + $userInfo.accountType + `
           "', channel =  '" + $userInfo.channel + `
           "', initials =  '" + $userInfo.initials + `
           "', roles =  '" + $roles + `
           "', passwordExpires =  '" + $userInfo.passwordExpiration + `
           "', title =  '" + $userInfo.title + `
           "', locale =  '" + $userInfo.locale + `
           "', account =  '" + $userInfo.account + `
           "', phone =  '" + $userInfo.phone + `
           "' WHERE users.email = '"+ $userInfo.email +"';"

           runquery($nquery)

    }




