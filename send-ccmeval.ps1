function Get-CCMEvalResult
{
    <#             .Synopsis             
      Get the results of the most recent client health evaluation on a local or remote computer             
      .DESCRIPTION             
      Parses the ccmevalreport.xml file into a readable format to view the results of the ccmeval task.  Can be run on the local or remote computer.             
      .EXAMPLE             
      Get-CCMEvalResult Returns the ccmeval results from the local machine             
      .EXAMPLE
      Get-CCMEvalResult -ComputerName PC001 Returns the ccmeval results from a remote machine             
      .EXAMPLE             
      'PC001','PC002' | Get-CCMEvalResult Returns the ccmeval results from a remote machine     
      #>
 
    #requires -Version 2
 
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true
        )]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
 
    Begin {
        $Script = {
            $TargetFile = "C:\Windows\CCM\CcmEvalReport.xml"
            try
            {
                Start-Process -FilePath powershell.exe -ArgumentList "-Command ""&{Copy-Item C:\Users\Administrator\Documents\CcmEvalReport.xml $TargetFile -Force}""" -Wait -ErrorAction Stop  -Verb Runas -WindowStyle Hidden
            }
            catch
            {
                $_.Exception.Message
                continue
            }
 
            if (!(test-path $TargetFile))
                {
                    Write-Error -Message "Could not locate the CcmEvalReport.xml"
                    continue
                }
 
            $xml = New-Object -TypeName System.Xml.XmlDocument
            $xml.Load($TargetFile)
            Remove-Item $TargetFile -Force
            return $xml
        }
    }
 
    Process {
        if ($ComputerName -eq $env:COMPUTERNAME)
        {
            $xml = Invoke-Command -ScriptBlock $Script
        }
        Else
        {
            try
                {
                    $xml = Invoke-Command -ScriptBlock $Script -ComputerName $ComputerName -ErrorAction Stop
                }
            catch
                {
                    if ($Error[0] | Select-String -Pattern 'Access is denied')
                        {
                            $Credentials = $host.ui.PromptForCredential('Credentials required', "Access was denied to $Computername.  Enter credentials to connect.", '', '')
                            $xml = Invoke-Command -ScriptBlock $Script -ComputerName $ComputerName -Credential $Credentials
                        }
                    Else { $_.Exception.Message }
                }
        }
 
        $Checks = $xml.ClientHealthReport.HealthChecks.HealthCheck |
        Select-Object -Property @{
            l = 'Test'
            e = {
                $_.Description
            }
        }, @{
            l = 'Result'
            e = {
                $_.'#text'
            }
        } |
        Sort-Object -Property Test
        [array]$Summary = $xml.ClientHealthReport.Summary |
        Select-Object -Property @{
            l = 'ComputerName'
            e = {
                $ComputerName
            }
        }, @{
            l = 'EvaluationTime'
            e = {
                [datetime]($_.EvaluationTime)
            }
        }, @{
            l = 'Result'
            e = {
                $_.'#text'
            }
        }
 
        $Summary
        $Checks | Format-Table
    }
}
