[CmdletBinding()]
    param(
        [Parameter(Mandatory=$False)]
        [String]$ComputerName = $env:COMPUTERNAME
        )
 
# Code to set 'SendAlways' in registry
$SendAlways = {
    Param($Value)
    $Path = "HKLM:\Software\Microsoft\CCM\CcmEval"
 
    Try
    {
        $null = New-ItemProperty -Path $Path -Name 'SendAlways' -Value $Value -Force -ErrorAction Stop
    }
    Catch
    {
        $_
    }
}
 
# Run against local computer
If ($ComputerName -eq $env:COMPUTERNAME)
{
    If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Warning "This cmdlet must be run as administrator against the local machine!"
        Return
    }
 
    Write-Verbose "Enabling 'SendAlways' in registry"
    $Result = Invoke-Command -ArgumentList "TRUE" -ScriptBlock $SendAlways
 
    If (!$Result.Exception)
    {
        Write-Verbose "Triggering CM Health Evaluation task"
        Invoke-Command -ScriptBlock { schtasks /Run /TN "Microsoft\Configuration Manager\Configuration Manager Health Evaluation" /I }
 
        Write-Verbose "Waiting for ccmeval to finish"
        do {} while (Get-process -Name ccmeval -ErrorAction SilentlyContinue)
 
        Write-Verbose "Disabling 'SendAlways' in registry"
        Invoke-Command -ArgumentList "FALSE" -ScriptBlock $SendAlways
    }
    Else
    {
        Write-Error $($Result.Exception.Message)
    }
}
# Run against remote computer
Else
{
    Write-Verbose "Enabling 'SendAlways' in registry"
    $Result = Invoke-Command -ComputerName $ComputerName -ArgumentList "TRUE" -ScriptBlock $SendAlways
 
    If (!$Result.Exception)
    {
        Write-Verbose "Triggering CM Health Evaluation task"
        Invoke-Command -ComputerName $ComputerName -ScriptBlock { schtasks /Run /TN "Microsoft\Configuration Manager\Configuration Manager Health Evaluation" /I }
 
        Write-Verbose "Waiting for ccmeval to finish"
        do {} while (Get-process -ComputerName $ComputerName -Name ccmeval -ErrorAction SilentlyContinue)
 
        Write-Verbose "Disabling 'SendAlways' in registry"
        Invoke-Command -ComputerName $ComputerName -ArgumentList "FALSE" -ScriptBlock $SendAlways
    }
    Else
    {
        Write-Error $($Result.Exception.Message)
    }
}
