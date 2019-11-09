﻿$a = $env:USERNAME
$b = $env:COMPUTERNAME
Write-Information 'Username: '$a
Write-Verbose -Message 'ComputerName: {1} ', -f
Write-Information 'Press any key to exit ...'
$x = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')


Get-Service | ForEach-Object -Process {
  if ($_.Status -eq 'Running') 
  {
    $_ 
  } 
}

Unlock-ADAccount -Identity 'CN=service-omc-south-digsend,OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil'


$a = (Get-ADComputer -Filter 'Name -like "D*"' -searchbase 'OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil'-Properties IPv4Address |
  Where-Object -Property IPv4Address -Like -Value '214.18.*.*' |
Format-Table -Property Name -AutoSize)
$a | Out-File -FilePath Workstations.txt
.count

Set-Location -Path 'E:\Scripts\test'
$a = Get-Content -Path Workstations.txt
$a | ForEach-Object -Process {
  if (!(Get-HotFix -Id KB3114409 -ComputerName $_)) 
  {
    $_ | Out-File -FilePath Installed-KB3114409.txt
  }
}


Add-Content -Value $_ -Path Installed-KB3114409.txt 

# User logged on to a physical box
$a = (Get-ADComputer -Filter 'Name -like "D*"' -searchbase 'OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil'-Properties IPv4Address |
  Where-Object -Property IPv4Address -Like -Value '214.18.*.*' |
Format-Table -Property Name -AutoSize)
Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName


# Owners of explorer.exe processes (desktop is an Explorer process)
Get-WmiObject -Class Win32_Process -Filter 'Name="explorer.exe"'  |
ForEach-Object -Process {
  $owner = $_.GetOwner()
  '{0}\{1}' -f  $owner.Domain, $owner.User
} | 
Sort-Object -Unique



