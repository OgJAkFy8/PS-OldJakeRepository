#!/usr/bin/env powershell
#requires -version 3

<#
    .SYNOPSIS
    Moves VM's to the Hosts they are tagged.

    .DESCRIPTION
    The script checks the "tag" on each server and moves it to the host with the matching tag.

    .INPUTS
    <None>

    .OUTPUTS
    Log file stored in C:\Temp\Move-VMtoBalanceServers.log

    .NOTES
    Version:        1.0
    Author:         eja
    Creation Date:  1/1/2018
    Purpose/Change: Initial script development
  
    .EXAMPLE
    Move-VMtoBalanceServers.ps1
#>

#----------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Dot Source required Function Libraries
. "$env:HOMEDRIVE\Scripts\Functions\Logging_Functions.ps1"

#----------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '1.0'

#Log File Info
$sLogPath = "$env:HOMEDRIVE\Temp"
$sLogName = 'Move-VMtoBalanceServers.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

# Assign hosts 
$host18 = '214.54.192.18'
$host19 = '214.54.192.19'

# Get vm's with tags
$tagged18 = get-vm -tag 'host_18'
$tagged19 = get-vm -tag 'host_19'

# Get vm's 
$vm = Get-vm

#---------------------[Functions]------------------------------------------------------------

<#

Function <FunctionName>{
 Param()

Begin{
	Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
}

Process{
	Try{
		<code goes here>
	}

	Catch{
		Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
		Break
	}
}

End{
	If($?){
		Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
		Log-Write -LogPath $sLogFile -LineValue " "
	}
}
}
#>


#---------- [Execution]------------------------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
#Script Execution goes here
#Log-Finish -LogPath $sLogFile

$i = 1
$k = 100 / $vm.count

# Move VM's to hosts based on tags
foreach($server in $vm){

	Write-Progress -Activity "Moving Servers" -Status "$i% Complete:" -PercentComplete $i
	
	if(($server.vmhost.name -ne $host18) and ($server.tag -match 'host_18')){
		# Write-Host "Moving $server to Host-18"
		move-vm -name $server -Destination $host18 #-whatif
	}
	if({$server.vmhost.name -ne $host19} and {$server.tag -match 'host_19'}){
		# Write-Host "Moving $server to Host-19"
		move-vm -name $server -Destination $host19 #-whatif
	}
	$i = $i + $k
}

# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU10nEqlD12YGuH40PJDi0vG1C
# hgegggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUtXJLkayZpRpFyUCAtIsixsJNNsYw
# DQYJKoZIhvcNAQEBBQAEgYAmuosLv6sxF1vAlWwJvGH/Sm95zmEd9NXuVSbSNm4t
# 7tGicPndPnGEo7g6CTSc/9lI2c1eBOC/QvVPp4g4il9FTPx725XxVkfOuIfiL8I3
# K7E//Q8jKrffp/YlvCzM2i8WmYtnQxpCqQ8Wm79G9jTXclvlXAnRtdOo2mgYUC3R
# nA==
# SIG # End signature block
