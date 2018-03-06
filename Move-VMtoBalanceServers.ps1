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

# Move VM's to hosts based on tags
foreach($server in $tagged18){
  if($server.vmhost.name -ne $host18){
    # Write-Host "Moving $server to Host-18"
    move-vm -name $server -Destination $host18 #-whatif
  }
}
    
foreach($server in $tagged19){
  if($server.vmhost.name -ne $host19){
    # Write-Host "Moving $server to Host-19"
    move-vm -name $server -Destination $host19 #-whatif
  }
}
 
