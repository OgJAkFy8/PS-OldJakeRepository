#requires -Version 3.0 -Modules NetTCPIP

$Workstation = 'localhost'
try
{
  #$NIC = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*
  $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property * -ExcludeProperty IPX*, WINS*
}
# NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
# some InvocationInfo details such as ScriptLineNumber.
# REMEDY: If that affects you, remove the SPECIFIC exception type [System.Management.Automation.ValidationMetadataException] in the code below
# and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
# add the logic to handle different error types differently by yourself.
catch [Management.Automation.ValidationMetadataException]
{
  # get error record
  [Management.Automation.ErrorRecord]$e = $_

  # retrieve information about runtime error
  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  
  # output information. Post-process collected info, and log info (optional)
  $info
}

foreach($NIC in $NICs)
{
  $Delimeter = ':'
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'Description', $Delimeter, $NIC.Description)
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'DefaultIPGateway', $Delimeter, $NIC.DefaultIPGateway[0])
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'DHCPEnabled', $Delimeter, $NIC.DHCPEnabled)
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'DHCPServer', $Delimeter, $NIC.DHCPServer)
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'DNSHostName', $Delimeter, $NIC.DNSHostName)
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-14}{3,-14}' -f 'DNSServerSearchOrder', $Delimeter, $NIC.DNSServerSearchOrder[0], $NIC.DNSServerSearchOrder[1])
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'IPAddress', $Delimeter, $NIC.IPAddress[0])
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'IPSubnet', $Delimeter, $NIC.IPSubnet[0])
  Write-Output -InputObject ('{0,-23}{1,-4}{2,-24}' -f 'MACAddress', $Delimeter, $NIC.MACAddress)
}

$ExternalIp = Invoke-RestMethod -Uri http://ipinfo.io/json | Select-Object -ExpandProperty ip
Test-NetConnection -ComputerName $ExternalIp -TraceRoute 

