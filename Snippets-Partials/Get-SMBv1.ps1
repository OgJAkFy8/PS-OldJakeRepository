$Results = @()
$Computers = Get-Content .\ServerList.txt
 
ForEach ($Computer In $Computers)
{
  $SMBv1 = Invoke-Command -ComputerName $Computer -ScriptBlock {
    Get-SmbServerConfiguration | Select-Object  -Property EnableSMB1Protocol
  }
  $Properties = @{
    MachineName  = $SMBv1.PSComputerName
    SMBv1Enabled = $SMBv1.EnableSMB1Protocol
  }
  $Results += New-Object  -TypeName psobject -Property $Properties
}
 
$Results |
Select-Object  -Property MachineName, SMBv1Enabled |
Format-Table
