# include resource file
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory Resource.ps1)

while("1" -eq "1")
	{
		$getIDsQ = "SELECT * from tmp_agreements WHERE inProcess = '0' LIMIT 200"
		try
			{
				$agIdsList = runquery($getIDsQ)
				if($agIdsList.count -gt 0)
					{
						Write-Host "Got a list. `n`n"
						$idlist1 = $agIdsList
						$idlist1
						foreach($id1 IN $idlist1)
							{
								$stringnow = "Setting inProcess flag for: "+ $id1.AgId +"`n"
								Write-Host $stringnow
								$setInProcessQuery = "UPDATE tmp_agreements SET inProcess = '1' where AgId = '" + $id1.AgId + "';"
								runquery($setInProcessQuery)
							}
						foreach($id1 IN $idlist1)
							{
								$stringnow = "CW Running GetAgreementInfo for "+ $id1.AgId +". `n"
								Write-Host $stringnow
								getAgreementInfo $id1.AgId
								$stringnow = "Deleting tmp_agreements row for: "+ $id1.AgId +". `n"
								Write-Host $stringnow
								$deletTmpRowQ = "DELETE from tmp_agreements where AgId = '" + $id1.AgId + "' AND inProcess = '1';"
								runquery($deletTmpRowQ)
								continue
							}
					$nowt = get-date -format s
					$logtxt1 = "Ended run of **" + $agIdsList.count + "** DocInfo calls/SQl updates at: " + $nowt
					logger $logtxt1	
					}
				if($agIdsList.count -eq 0)
					{
						Write-Host "CW There were no new agreements in the temp table!  Sleeping 30 seconds.`n`n"
						Start-Sleep -Seconds 30
					}
				if($idlist1){Remove-Variable idlist1}
			}
		catch
			{
				Write-Host "$error[0]"
				Start-Sleep -Seconds 30
				continue
			}
		if($idlist1){Remove-Variable idlist1}
		if($agIdsList){Remove-Variable agIdsList}
		Start-Sleep -Seconds 2
			
	}