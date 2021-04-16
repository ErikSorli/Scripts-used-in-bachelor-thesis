[CmdletBinding()]
    param(
        [Parameter(Mandatory=$False)]
        [String]$ComputerName = $env:COMPUTERNAME
        )

# Checks if the computer is running on the correct 
If ($ComputerName -eq $env:COMPUTERNAME)
{
    If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Warning "Run cmdlet as Admin!"
        Return
    }
   #Starting the process that checks the current health check for the given computer
   WriteOutput "Starting ccm health check for $ComputerName"
   Start-Process -Filepath "C:\Windows\CCM\CcmEval.exe"
   do{
        
    }while (Get-Process -ComputerName $ComputerName -Name CcmEval.exe -ErrorAction SilentlyContinue)
    #Sending the report to Config Manager
    #Copy-Item -Path C:\Windows\CCM\CcmEval.xml -Destination '\S\Log' -ToSession(New-PSSession -ComputerName MANAGER.HDO.local)
}
