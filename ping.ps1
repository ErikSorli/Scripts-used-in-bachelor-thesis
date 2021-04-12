#script for pinging all the client machines
#path for script
Set-Location -Path C:\Users\Administrator\Documents\Testing
#Return all the computernames from the domain, printing it to a text file
(Get-ADComputer -Filter * -Property *).Name | Out-File -FilePath .\client-machines.txt
#Variables
$PingClient = Get-Content "client-machines.txt"
$date = Get-Content "client-machines.txt"
Write-Output "Start log" `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\replies.log
Write-Output "Start log" `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\noreplies.log

Foreach($SystemName in $PingClient)
     $PingStatus = Get.Ciminstance Win32_pingstatus -filter "Address = '$SystemName'" | -erroraction SilentlyContinue | Select-Object address, StatusCode
     If($Pingstatus.StatusCode -eq 0){
       Write-output "$SystemName is alive"
       Write-Output "$SystemName is alive" `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\replies.log
} else{ 
       Write-output "$SystemName is dead"
       Write-Output "$SystemName is dead" `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\noreplies.log
}
Write.Output `r "Run on $date" "by env:username at env:ComputerName" `r "End log" `r `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\replies.log

Write.Output `r "Run on $date" "by env:username at env:ComputerName" `r "End log" `r `r | Out-File -FilePath C:\Users\Administrator\Documents\Testing\noreplies.log
Foreach($Systemname in $PingClient)
{
    systeminfo.exe /s $Systemname | findstr /i "OS version"
}
