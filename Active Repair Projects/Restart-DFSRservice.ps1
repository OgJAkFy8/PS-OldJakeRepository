#requires -Version 2.0
function Restart-DFSRservice
{
  # Requirements VMware PowerCLI 4.1
 
  #Get-Service -ComputerName COMPNAMENGMFS02 -Name "DFSR" -dependentservices | Where-Object {$_.Status -eq "Running"} |Select -Property Name



  <#
      .SYNOPSIS
      Check to see if DFSR service is running on the FS02 server and stops it for restarting the server.
      Great for rebooting the server without having to log into the server to stop the service.

      .DESCRIPTION
      Check to see if DFSR service is running on the FS02 server and stops it for restarting the server.  Great for rebooting the server without having to log into the server to stop the service.

      .EXAMPLE
      DFSR_Service_Test-and-Restart
      Describe what this call does

      .NOTES
      Script Name: DFSR_Service_Test-and-Restart.ps1
      Author Name: Erik Arnesen
      Version : 1.0 
      Contact : 5276

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online DFSR_Service_Test-and-Restart

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
 
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $false, Position = 0)]
    [System.String]
    $ServerName = 'FileServerName'
  )
  
  $ServiceStatus = 'Running'
  
  $ServiceName = 'DFSR'
  $SelectedService = Get-Service -ComputerName $ServerName -Name $ServiceName #-DependentServices
  $UserAnswer = 'N'
  if ($SelectedService.Status -eq 'Stopped')
  {
    Write-Host 'DFS Replication Service is Off.... '
    $UserAnswer = Read-Host -Prompt 'Do you want to start it? [N]'
    if($UserAnswer -eq 'Y')
    {
      Write-Verbose -Message 'Starting Service...'
      Set-Service -ComputerName $ServerName -Name $ServiceName-Status -ComputerName $ServiceStatus -StartupType Automatic
    }
  }
  
  if ($SelectedService.Status -eq $ServiceStatus)
  {
    Write-Host 'DFS Replication Service is On....'
    $UserAnswer = Read-Host -Prompt 'Do you want to stop it? [N]'
    if($UserAnswer -eq 'Y')
    {
      Write-Verbose -Message 'Stopping Service...'
      Get-Service -ComputerName $ServerName -Name $ServiceName | Stop-Service -Force
    }
  }
  Get-Service -ComputerName $ServerName -Name $ServiceName |   Select-Object -Property Status, Name
}


# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUUtB/H3hctqxz4mWNjEc4Ol0G
# hiqgggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
# MBYxFDASBgNVBAMTC0VyaWtBcm5lc2VuMB4XDTE3MTIyOTA1MDU1NVoXDTM5MTIz
# MTIzNTk1OVowFjEUMBIGA1UEAxMLRXJpa0FybmVzZW4wgZ8wDQYJKoZIhvcNAQEB
# BQADgY0AMIGJAoGBAKYEBA0nxXibNWtrLb8GZ/mDFF6I7tG4am2hs2Z7NHYcJPwY
# CxCw5v9xTbCiiVcPvpBl7Vr4I2eR/ZF5GN88XzJNAeELbJHJdfcCvhgNLK/F4DFp
# kvf2qUb6l/ayLvpBBg6lcFskhKG1vbEz+uNrg4se8pxecJ24Ln3IrxfR2o+BAgMB
# AAGjYDBeMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEcGA1UdAQRAMD6AEMry1NzZravR
# UsYVhyFVVoyhGDAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlboIQyWSKL3Rtw7JMh5kR
# I2JlijAJBgUrDgMCHQUAA4GBAF9beeNarhSMJBRL5idYsFZCvMNeLpr3n9fjauAC
# CDB6C+V3PQOvHXXxUqYmzZpkOPpu38TCZvBuBUchvqKRmhKARANLQt0gKBo8nf4b
# OXpOjdXnLeI2t8SSFRltmhw8TiZEpZR1lCq9123A3LDFN94g7I7DYxY1Kp5FCBds
# fJ/uMYIBSjCCAUYCAQEwKjAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlbgIQyWSKL3Rt
# w7JMh5kRI2JlijAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUPoA8skELU+rJrC6uuY+2sxAn45Aw
# DQYJKoZIhvcNAQEBBQAEgYAgOSvDgHdzC9a1n0gdPVqHEWqVro1peHneHiOMOZ5x
# eGxKycbkI5glDruo8rDUQPvQoyfTYjTHDdaJx5S3yTQvdUmWPwftT6VPPVTBCBNU
# IA6LevqLdSb9TLpEi3ZFpUSLVy2syGTwar5qVAFqfW3sPrcy/MAoo0JmlkvW4cpp
# 6w==
# SIG # End signature block
