$Workstation = 'localhost'
try
{
  $lenovo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*
}
# NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
# some InvocationInfo details such as ScriptLineNumber.
# REMEDY: If that affects you, remove the SPECIFIC exception type [System.Management.Automation.ValidationMetadataException] in the code below
# and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
# add the logic to handle different error types differently by yourself.
catch [System.Management.Automation.ValidationMetadataException]
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


$lenovo.MACAddress

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"}
Foreach($NIC in $NICs) {
$NIC.EnableDHCP()
$NIC.SetDNSServerSearchOrder()
}