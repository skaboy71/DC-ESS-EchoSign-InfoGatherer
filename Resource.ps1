#  Requirements to use this tool:
#  .Net Connector for MySql
#  MySQL 5.6 or newer Server
#  Database for data with User access
#  Powershell 4.0
# 
#############################################################################################
#  *********** Please modify file config.json to match your environment  *****************
#############################################################################################
# Get config data from ./config.json
$confObject = Get-Content -Raw -Path "./config.json" | ConvertFrom-Json
# mysql Server (name or IP)
$sqlServer = $confObject.sqlServer
# database name
$dbname = $confObject.dbname
# User with access to data 
$global:dbuser = $confObject.dbuser
# mysql DB Password
$global:dbpass = $confObject.dbpass
# API or integration Key
$global:apiKey = $confObject.apiKey

#############################################################################################
#  *********** Please modify file config.json to match your environment  *****************
#############################################################################################

# Users URL for REST. More info on the REST API can be found here:  https://secure.echosign.com/public/docs/restapi/v3
$global:userRec = "https://api.echosign.com/api/rest/v3/users"

# Doc URL for REST 
$global:docResource = "https://secure.echosign.com:443/api/rest/v3/agreements"

# Search URL for events REST
$global:eventsResource = "https://secure.echosign.com:443/api/rest/v3/search/agreementAssetEvents"

$global:startDate = [datetime]"2014-02-06"

#######################################################################################################
#   ***** RUN_MYSQL_QUERY   *****
#######################################################################################################

Function Run-MySQLQuery {
<#
.SYNOPSIS
   run-MySQLQuery
    
.DESCRIPTION
   By default, this script will:
    - Will open a MySQL Connection
	- Will Send a Command to a MySQL Server
	- Will close the MySQL Connection
	This function uses the MySQL .NET Connector or MySQL.Data.dll file
     
.PARAMETER ConnectionString
    Adds the MySQL Connection String for the specific MySQL Server
     
.PARAMETER Query
 
    The MySQL Query which should be send to the MySQL Server
	
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;database=project;" -Query "SELECT * FROM firsttest" 
    
    Description
    -----------
    This command run the MySQL Query "SELECT * FROM firsttest" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword and selects the database project
         
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;database=project;" -Query "UPDATE firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
    
    Description
    -----------
    This command run the MySQL Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword
	
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;" -Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
    
    Description
    -----------
    This command run the MySQL Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword and selects the database project
    
#>
	Param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = '',
            ValueFromPipeline = $true)]
            [string]$query,   
		[Parameter(
            Mandatory = $true,
            ParameterSetName = '',
            ValueFromPipeline = $true)]
            [string]$connectionString
        )
	Begin {
		Write-Verbose "Starting Begin Section"		
    }
	Process {
		Write-Verbose "Starting Process Section"
		try {
			# load MySQL driver and create connection
			Write-Verbose "Create Database Connection"
			# You could also could use a direct Link to the DLL File
			# $mySQLDataDLL = "C:\scripts\mysql\MySQL.Data.dll"
			# [void][system.reflection.Assembly]::LoadFrom($mySQLDataDLL)
			[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
			$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
			$connection.ConnectionString = $ConnectionString
			Write-Verbose "Open Database Connection"
			$connection.Open()
			
			# Run MySQL Querys
			Write-Verbose "Run MySQL Querys"
			$command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
			$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
			$dataSet = New-Object System.Data.DataSet
			$recordCount = $dataAdapter.Fill($dataSet, "data")
			$dataSet.Tables["data"]
		}		
		catch {
			Write-Host "Could not run MySQL Query '$query'" $Error[0]	
		}	
		Finally {
			Write-Verbose "Close Connection"
			$connection.Close()
		}
    }
	End {
		Write-Verbose "Starting End Section"
	}
}
#######################################################################################################
#   ***** GET_START_STOP_ARRAY   *****
#######################################################################################################

function getStartStopArray($g)
	{
		#  This function is used to create an array of
		#  start/stop datetime stamps to use for gathering all event data for
		#  each user in the account. It takes a single parameter of a datetime.
		#  It will create a global hashtable Var "$StartStopArray"
		#  The values can be access via $StartStopArray.name[] for the "start" 
		#  and $StartStopArray.value[] for the "end" of each 7 day range
		#  I call it like this:
		#  $dateStartIt = "02-06-2014"
		#  $startHt = [datetime]$dateStartIt
		#  getStartStopArray $startHt
		#  ********************


		$startIt = $g
		# set checkit 
		$checkIt = $startIt
		# set stop point
		$tempStop = (Get-Date).AddMinutes(-5)
		$stopIt = Get-date $tempStop -format s  
		# initialize HashTable
		$startEndArr = $null
		$startEndArr = @{}
		# Create array from "start Date" for account to now-5 min by 7day incremments
		while ($checkIt -lt $tempStop)
		    {
		      # set Start from checkit
		     $startTemp = (get-date $checkIt -format s) + ".000"
			 # set Stop from checkit + 7 days
		     $endTemp1 = (Get-Date $startTemp).AddDays(7)
		     $endTemp2 = (Get-Date $endTemp1 -format s) +".000"
		     #write name-value to hash
		     $startEndArr.add($startTemp,$endTemp2)
		     # set checkit to last end
		     $checkIt = get-date $endTemp1
		    
		    }
		# Sort the results
		$StartStopArray = $startEndArr.GetEnumerator() | Sort Name
		return $StartStopArray
	}

#######################################################################################################
#   ***** RUN_QUERY   *****
#######################################################################################################

function runquery($query)
	{
		$runQuery = run-MySQLQuery -ConnectionString "Server=$sqlServer;Uid=$dbuser;Pwd=$dbpass;database=$dbname;" -Query  $query
		return $runQuery
	}
#######################################################################################################
#   ***** LOGGER   *****
#######################################################################################################

function logger($desccription, $agIID)
	{
		$l_string = [string]$MyInvocation.PSCommandPath
		$lquery = "INSERT INTO logging SET sc_name = '"+ $l_string + "', levDesc = '" + $desccription + "', AgId = '"+ $agIID +"'"
		$object = runquery($lquery)
	}
	
#######################################################################################################
#   ***** GET_AGREEMENT_INFO   *****
#######################################################################################################

function getAgreementInfo ($AgId1)
    {
		$thisID = $AgId1
		$callURL = $docResource + "/" + $thisID
		 Try
		        {
		            $AgreementInfo1 = Invoke-RestMethod -Method Get -Uri $callURL -Header  @{ "Access-Token" = $apiKey }  -ErrorAction Continue
		        }
		        Catch
		        {
		            $stringLog = "Got not REST Data for Agreement "+ $thisID
		            logger $stringLog $thisID
		            $nullthings=1
		        }
		$clearQuery = "DELETE IGNORE from participants where AgId = '" + $thisID + "';"
		runquery($clearQuery)
		$addStub = "INSERT IGNORE INTO agreements (AgId) values ('" + $thisID + "');"
		runquery($addStub)
		foreach($part1 IN $AgreementInfo1.participants)
		        {
		            $roles = $part1.roles -join ","
		            $inP1Q = "INSERT INTO participants (AgId, company, email, status, title, roles) VALUES `
		            ('"+$thisID+"', '"+ $part1.company +"', '"+ $part1.email +"','"+ $part1.status +"', '"+ $part1.title +"','"+ $roles +"');"
		            runquery($inP1Q)

		            if($part1.alternateParticipants.Count -gt 0)
		                    {
		                        foreach($altPart IN $part1.alternateParticipants)
		                            {
		                                $roles2 = $altPart.roles -join ","
		                                $inP2Q = "INSERT INTO participants (AgId, company, email, status, title, roles, delegateFor,isNext) `
		                                VALUES ('"+$thisID+"', '"+ $altPart.company +"', `
		                                '"+ $altPart.email +"','"+ $altPart.status +"', '"+ $altPart.title +"','"+ $roles2 +"','"+ $part1.email +"', '1');"
		                                runquery($inP2Q)
		                                
		                                foreach($event IN $AgreementInfo1.events)
		                                    {
		                                        if($event.participantEmail -eq $altPart.email -and $event.type -eq "DELEGATED")
		                                            {
		                                                $echo = "Found Delegated Event for the agreement "
		                                                logger $echo $thisID
		                                                $stamp = get-date $event.date -format s
		                                                $upAltSinceQ = "UPDATE participants SET since = '" + $stamp + "' where AgId = '" + $thisID + "' AND email = '"+ $altPart.email +"';"
		                                                runquery($upAltSinceQ)
		                                            }                                    
		                                    }
		                            }
		                        $upAgHasDelQ = "UPDATE agreements SET hasDelegates = 'true' where AgId = '" + $thisID + "';"
		                        runquery($upAgHasDelQ)
		                    }
		        }
		if($AgreementInfo1.nextParticipantInfos.Count -gt 0)
			{
				$nextParticipants = $AgreementInfo1.nextParticipantInfos
				foreach($nextp in $nextParticipants)
				        {
				            $timeStamp = get-date $nextp.waitingSince -format s            
				            $nxtUpQ = "UPDATE participants SET since = '"+ $timeStamp +"', isNext = '"+ 1 +"' where AgId = '" + $thisID +"' AND email = '" + $nextp.email +"';"
				            runquery($nxtUpQ)
				        }
			}
		foreach($eventRec IN $AgreementInfo1.events)
		    {
		        $StampEvent = get-date $eventRec.date -format s
		        if($eventRec.type -eq "CREATED"){$AgCreated = get-date $eventRec.date -format s}
				$sender = ($AgreementInfo1.participants | where {$_.roles -ccontains "SENDER"}).email
		        $checkitQ = "Select * from events where AgId = '" + $thisID + "' and EvType =  '" + $eventRec.type +"' and EvDateTime =  '" + $StampEvent + "';"
		        $checkNow = runquery $checkitQ
		        if($checkNow.tid)
		                        {

		                     $updateEventQ = "UPDATE events set AgId = '" + $thisID + `
		                           "', AgName = '" + $AgreementInfo1.name + `
		                           "', EvqFor =  '" + $sender + `
		                           "', EvAcEmail =  '" + $eventRec.actingUserEmail + `
		                           "', EvIpAd =  '" + $eventRec.actingUserIpAddress + `
		                           "', EvDateTime =  '" + $StampEvent + `
		                           "', EvDesc =  '" + $eventRec.description + `
		                           "', EvPtEmail =  '" + $eventRec.participantEmail + `
		                           "', EvType =  '" + $eventRec.type +"' where tid = '"+ $checkNow.tid +"';"
		                                runquery $updateEventQ
		                        }
		                    ELSE
		                        {
		                     $iEvnquery = "INSERT INTO events SET AgId = '" + $thisID + `
		                           "', AgName = '" + $AgreementInfo1.name + `
		                           "', EvqFor =  '" + $sender + `
		                           "', EvAcEmail =  '" + $eventRec.actingUserEmail + `
		                           "', EvIpAd =  '" + $eventRec.actingUserIpAddress + `
		                           "', EvDateTime =  '" + $StampEvent + `
		                           "', EvDesc =  '" + $eventRec.description + `
		                           "', EvPtEmail =  '" + $eventRec.participantEmail + `
		                           "', EvType =  '" + $eventRec.type + `
		                           "', EvVid =  '" + $eventRec.versionId + `
		                           "' ON DUPLICATE KEY UPDATE AgId = '" + $thisID + "';"
		                           runquery $iEvnquery
								}
		        if($eventRec.type -eq "DOCUMENTS_DELETED")
					{
						$stringLog = "Found Deleted event for Agreement "+ $thisID
		            			logger $stringLog $thisID
						$updateDeletedQ = "UPDATE agreements SET isDeleted = '1' where AgId ='" + $thisID +"';"
						runquery $updateDeletedQ
					}                   

		    }
		try {
		        $lastEventp = get-date ($AgreementInfo1.events | Sort-Object date | Select-Object -last 1).date -format s
		    }
		catch
		    {
		        $echo2 = "There was no date info for agreement "
		        logger $echo2 $thisID     
		    }
		    if($AgreementInfo1.nextParticipantInfos.Count -gt 0)
		            {
		                $nextData = $AgreementInfo1.nextParticipantInfos[0] -join ","
		            }
		    else
		            {
		                $nextData = ""
		            }
		    $AgreUpQuery1 = "UPDATE agreements SET AgName = '" + $AgreementInfo1.name + `
		                       "', lVerId =  '" + $AgreementInfo1.latestVersionId + `
		                       "', PartCount =  '" + $AgreementInfo1.participants.Count + `
		                       "', AgCreated =  '" + $AgCreated + `
		                       "', sender =  '" + $sender + `
		                       "', AgStatus =  '" + $AgreementInfo1.status + `
		                       "', nextInfo =  '" + $nextData + `
		                       "', LastEv =  '" + $lastEventp + `
		                       "' where AgId = '"+ $thisID +"';"
		            runquery($AgreUpQuery1)
		## Get for data to get transactionID
		$getFormDataUrl = "https://secure.echosign.com:443/api/rest/v4/agreements/" + $thisID + "/formData"
		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$headers.Add("Access-Token", $apiKey)
		
		Try
		        {
		            $formData = Invoke-RestMethod -Method Get -Uri $getFormDataUrl -Header $headers -ContentType 'application/json' -ErrorAction Continue
					$formDataObj = ConvertFrom-Csv $formData
					if($formDataObj[0].'Transaction Number')
						{
							## Write transaction ID to agreements table UPDATE
							$txUpdateQuery1 = "UPDATE agreements SET trxId = '" + $formDataObj[0].'Transaction Number' + "' where AgId = '"+ $thisID +"';"
							runquery($txUpdateQuery1)
						}
		        }
		        Catch
		        {
		            $stringLog = "Got formData error for Agreement "+ $thisID + "Got Error: " + $Error[0]
		            logger $stringLog $thisID
		            $nullthings=1
		        }
		 
    }
	
#######################################################################################################
#  *****  GET_MORE_EVENTS  *****
#######################################################################################################
function getMoreEvents($uId, $sId, $uEm, $nxtC, $lstC)
	{
		$userId1 = $uId
		$searchID = $sId
		$uemail = $uEm
		$np_curs = $nxtC
		$lastCursor = $lstC

		$msgString = "getmore --  Next Search cursor = " + $np_curs  + "`n`n"
		Write-Host $msgString
						
		while($np_curs -ne "")
					{
						$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		                $headers.Add("Access-Token", $apiKey)
		                $headers.Add("x-user-id",$userId1 )
						$moreEventsUrl = "https://secure.echosign.com:443/api/rest/v3/search/agreementAssetEvents/" + $searchID + "?pageCursor=" + $np_curs
						Try	
							{
						$events = Invoke-RestMethod -Method Get -Uri $moreEventsUrl -Header $headers -ContentType 'application/json' -ErrorAction Continue

							}
						Catch
							 {
							   $stringLog = $Error[0]   
		                       logger $stringLog $uemail
								if($error[0] -Match "INVALID_PAGE_CURSOR")
									{
										$events.nextPageCursor = $lastCursor
										continue
									}			
							 }

							 if($Error[0] -Match "NOT_FOUND"){continue}
							
					 if($events.events.Count -gt 0)
		            {
						Write-Host "Got " + $events.events.count +" events."
						$allEvents = $events.events | Sort-Object agreementAssetId | Get-Unique -AsString 
						Write-Host "Got " + $allEvents.count +" in Allevents events.`n`n"				
		                $stringLog2 = "Writing " + $allEvents.count + " for:"+ $uemail +" into db events table. Range "+ $startR+" => "+ $endR +"`n for SearchCursor:  " + $np_curs +"`n`n"
		                #logger $stringLog2 $uemail
						Write-Host $stringLog2

		                foreach($eventRecord IN $allEvents)
		                    {
			                    $timeStamp = get-date $eventRecord.documentHistoryEvent.date -format s
			                    $inquery = "INSERT IGNORE INTO agreements SET AgId = '" + $eventRecord.agreementAssetId + "' ;"
		                        runquery($inquery)
								$updateWorMq = "UPDATE IGNORE agreements SET AgType ='" + $eventRecord.agreementAssetType + "' WHERE AgId = '" + $eventRecord.agreementAssetId + "' ;"
								runquery($updateWorMq)
								
		                    }

						if($events.nextPageCursor -ne "")
							{
								$msgString = "getmore --  Next Search cursor = " + $events.nextPageCursor +"`n SearchID is " + $searchID + "`n`n"
								$lastCursor = $events.currentPageCursor
								Remove-Variable np_curs
								$np_curs = $events.nextPageCursor
							}
						Else
							{
								$msgString = "getmore --  nextPageCursor is empty!!"+"`n SearchID is " + $searchID + "`n`n"
								$np_curs = ""
							}
						Write-Host $msgString
					}
						ELSE
						{continue}
					}
					$stringLog3 = "Now leaving getMore script for SearchID `n" + $searchID + "`n`n"
					Write-Host $stringLog3
					Remove-Variable events
					Remove-Variable searchID
		return
	}
#######################################################################################################
#  *****  GET_EVENTS_ONE_RANGE  *****
#######################################################################################################

function getEventsOneRange($uId2, $R_start, $R_end, $t_email)
	{
		$userId1 = [string]$uId2
		$startR = [string]$R_start
		$endR = [string]$R_end
		$email = [string]$t_email

		Write-Host "This UserID = : $userId1"
		Write-Host "This StartRage = : $startR"
		Write-Host "This EndRange = : $endR"
		Write-Host "This user email = : $email `n`n"

		if($events)
			{
				Clear-Variable events
			}

		$body1 = @{
				    startDate = $startR
					# Use the next line to filter for specific events(testing this currently)
					# filterEvents = @('SIGNATURE_REQUESTED','SIGNED','ESIGNED','CREATED')
				    endDate = $endR
					pageSize = "200"
		          }

		$bodyJason = $body1 | ConvertTo-Json

		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$headers.Add("Access-Token", $apiKey)
		$headers.Add("x-user-id",$userId1 )

		Try
		    {
		        $string = "Invoke-RestMethod -Method Post -Uri $eventsResource -Header $headers -Body $bodyJason -ContentType 'application/json' -ErrorAction Continue"
		        $events = Invoke-RestMethod -Method Post -Uri $eventsResource -Header $headers -Body $bodyJason -ContentType 'application/json' -ErrorAction Continue
		    }
		Catch
		    {
			    $stringLog = "Got no REST event Data on "+ $user.email +" for "+ $startR+" => "+ $endR 
			    logger $stringLog $email
				Write-Host $Error[0]
				return
		    }

		if($events.events.Count -gt 0)
		    {
				Write-Host "Got " + $events.events.count +" events."
				$allEvents = $events.events | Sort-Object agreementAssetId | Get-Unique -AsString 
				if($allEvents.count -gt 0)
					{
						Write-Host "Got " + $allEvents.count +" in Allevents events."				
		                $stringLog2 = "Writing " + $allEvents.count + " for:"+ $email +" into db events table. Range "+ $startR+" => "+ $endR  + "`n`n"
		                logger $stringLog2 $email
						Write-Host $stringLog2

		                foreach($eventRecord IN $allEvents)
		                    {
			                    $timeStamp = get-date $eventRecord.documentHistoryEvent.date -format s
			                     $inquery = "INSERT IGNORE INTO agreements SET AgId = '" + $eventRecord.agreementAssetId + "' ;"
			                           runquery($inquery)
								$updateWorMq = "UPDATE IGNORE agreements SET AgType ='" + $eventRecord.agreementAssetType + "' WHERE AgId = '" + $eventRecord.agreementAssetId + "' ;"
								runquery($updateWorMq)
		                    }
					}
		    }
						
				if($events.nextPageCursor -eq ""){
													$stringLog = "There was no next page for user "+ $email +" for range "+ $startR+" => "+ $endR  + "`n`n"
		                       						logger $stringLog $email 
							   					}
				
				if($events.nextPageCursor -ne ""){
													Write-Host "There was a page cursor... Get more events!!"
													Write-Host "`n`n"
													$stringOut1 = "Starting getMore for SearchID " + $events.searchId
													Write-Host $stringOut1
													$stringOut2 = "Using 1st NPC " + $events.nextPageCursor
													Write-Host $stringOut2
													Write-Host "`n`n"
													#pause
													
													$searchIDstring = $events.searchId
													$np_cursor = $events.nextPageCursor
													$cp_cursor =  $events.currentPageCursor
													Remove-Variable events
													
													getMoreEvents $userId1 $searchIDstring $email $np_cursor $cp_cursor
													
												}
												
		return
	}
#######################################################################################################
#  *****  GET_HISTORY_EVENTS_ONE_USER  *****
#######################################################################################################	

function getHistoryFor1User($StartDate, $u_email, $u_id)
	{
		
		if($args[0])
			{
				$dateStartIt = $StartDate
				Write-Host "`n`n ***** GetHistAgEvtsFor1 starting Using passed start date of $dateStartIt . *****`n`n" 
			}
		else
			{
				$dateStartIt = $global:startDate
				Write-Host "`n`n *****GetHistAgEvtsFor1 starting Using Global startDate of $global:startDate . *****`n`n"
			}

		$startHt = [datetime]$dateStartIt
		$StartStopArray = getStartStopArray $startHt

		if($u_email -and $u_id)
			{
				$email1 = $u_email
				$userId1 = $u_id
				$logtext = "*** Starting history for " + $email1 + " with user ID: " + $userId1
				$hostText = $Myinvocation.mycommand.name + " *** Starting history for " + $email1 + " with user ID: " + $userId1
				Write-Host $hostText
				logger $logtext
			}
		Else
			{
				ho$logtext = "*** Got no parameters for this run. Now exiting!"
				$hostText = $Myinvocation.mycommand.name + "*** Got no parameters for this run. Now exiting!"
				Write-Host $hostText
				logger $logtext
				pause
				Exit
		
			}


		        
		        foreach ($range IN $StartStopArray)
		            {
		                if($global:events){Clear-Variable events -Scope Global}
						if($global:lastDateStart){Remove-Variable lastDateStart -Scope Global}
						$global:lastDateStart = $range.Name
		                getEventsOneRange $userId1 $range.Name $range.Value $email1
		            }

		    
		    


		   
	}
	
