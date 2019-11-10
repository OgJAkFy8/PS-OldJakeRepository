#requires -Version 3.0
function Get-SMBv1
{
  <#
      .SYNOPSIS
      Returns the status of a server's SMBv1 status

      .DESCRIPTION
      Returns the status of a server's SMBv1 status

      .EXAMPLE
      Get-SMBv1 -Computers 'server1','server2'

      .EXAMPLE
      Get-SMBv1 -ComputerFile .\serverlist.txt
      
  #>
  [cmdletbinding(DefaultParameterSetName = 'Computers',SupportsPaging = $true)]
  param
  (
    [Parameter(Position = 0,ParameterSetName = 'Computers')]
    [string[]]  $Computers = 'localhost',
    [Parameter(Mandatory,HelpMessage = 'Add a file name and path from a text file', Position = 0,ParameterSetName = 'ComputerFile')]
    [String]$ComputerFile
  )
  
  $Results = @()
  if ($ComputerFile)
  {
    $Computers = Get-Content -Path $ComputerFile
  }
  
  ForEach ($Computer In $Computers)
  {
    $SMBv1 = Invoke-Command -ComputerName $Computer -ScriptBlock {
      Get-SmbServerConfiguration | Select-Object  -ExpandProperty EnableSMB1Protocol
    }
    $Properties = @{
      MachineName  = $SMBv1.PSComputerName
      SMBv1Enabled = $SMBv1.EnableSMB1Protocol
    }
    $Results += New-Object  -TypeName psobject -Property $Properties
  }
  
  $Results | Select-Object  -Property MachineName, SMBv1Enabled
}


