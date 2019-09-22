#requires -Version 3.0 -Modules NetTCPIP
function Ping-NetConnection
{
  <#
    .SYNOPSIS
    Short Description
    .DESCRIPTION
    Detailed Description
    .EXAMPLE
    Ping-NetConnection
    explains how to use the command
    can be multiple lines
    .EXAMPLE
    Ping-NetConnection
    another example
    can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $TestName = 'DNS Server',
    
    [Parameter(Mandatory=$false, Position=1)]
    [System.String]
    $ComputerName = '127.0.0.1'
  )
  
  $DnsServer = Test-Connection $ComputerName 
  Write-Host ('Testing the {0} connection' -f $TestName) -ForegroundColor Yellow
  Write-Host ('Loopback Interface Alias:  {0}' -f $DnsServer.InterfaceAlias) -ForegroundColor Gray
  Write-Host ('{0} Ping Succeeded: {1}' -f $TestName,$DnsServer.PingSucceeded) -ForegroundColor Gray
}
$Workstation = 'localhost'
try
{

  Write-Host ("Gathering the information on your NIC's") -ForegroundColor Yellow
  $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property * -ExcludeProperty IPX*, WINS*
}

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

#Write-Host ("Gathering the information on your NIC's") -ForegroundColor Yellow
foreach($NIC in $NICs)
{
  $Delimeter = ':'
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'Description of ', $Delimeter, $NIC.Description)
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DNSHostName', $Delimeter, $NIC.DNSHostName)
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'IPAddress', $Delimeter, $NIC.IPAddress[0])
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'IPSubnet', $Delimeter, $NIC.IPSubnet[0])
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DefaultIPGateway', $Delimeter, $NIC.DefaultIPGateway[0])
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-14}{3,-14}' -f 'DNSServerSearchOrder', $Delimeter, $NIC.DNSServerSearchOrder[0], $NIC.DNSServerSearchOrder[1])
  #Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DHCPEnabled', $Delimeter, $NIC.DHCPEnabled)
  if(!($NIC.DHCPEnabled)){Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DHCPServer', $Delimeter, $NIC.DHCPServer)}
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'MACAddress', $Delimeter, $NIC.MACAddress)
}

Write-Host ('Testing the internet connection and Trace Routing the External IPAddress') -ForegroundColor Yellow

$ExternalIp = Invoke-RestMethod -Uri http://ipinfo.io/json | Select-Object -ExpandProperty ip
$ExternalIpTest = Test-NetConnection -ComputerName $ExternalIp -TraceRoute 
write-host $ExternalIpTest.TraceRoute[0] 
Write-Host 'External IP Test'
Write-Host ''
$Hops = ($ExternalIpTest.TraceRoute).count

if($nic.DNSHostName){
Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DNSHostName', $Delimeter, $NIC.DNSHostName)
$TestAnswer = Test-Connection $nic.DNSHostName -Quiet
Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'Ping HostName', $Delimeter, $TestAnswer)
}


if($NIC.IPAddress[0]){
Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'IPAddress', $Delimeter, $NIC.IPAddress[0])
$TestAnswer = Test-Connection $NIC.IPAddress[0] -Quiet
Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'Ping IpAddress', $Delimeter, $TestAnswer)
}


[ipaddress]$IpAddress = $NIC.IPAddress[0]


Write-Host ('Testing the Loopback connection') -ForegroundColor Yellow
$Loopback = Test-NetConnection -ComputerName 127.0.0.1
Write-Host ('Loopback Interface Alias:  {0}' -f $Loopback.InterfaceAlias) -ForegroundColor Gray
Write-Host ('Loopback Ping Succeeded: {0}' -f $Loopback.PingSucceeded) -ForegroundColor Gray

Write-Host ('Testing the Gateway connection') -ForegroundColor Yellow
$Gateway = Test-NetConnection -ComputerName $NIC.DefaultIPGateway[0]
Write-Host ('Loopback Interface Alias:  {0}' -f $Gateway.InterfaceAlias) -ForegroundColor Gray
Write-Host ('Loopback Ping Succeeded: {0}' -f $Gateway.PingSucceeded) -ForegroundColor Gray

$TestName = 'DNS Server'
$ComputerName = '127.0.0.1'
$DnsServer = Test-NetConnection -ComputerName $ComputerName 
Write-Host ("Testing the $TestName - $($DnsServer.ComputerName) connection") -ForegroundColor Yellow
Write-Host ('Loopback Interface Alias:  {0}' -f $DnsServer.InterfaceAlias) -ForegroundColor Gray
Write-Host ('{0} Ping Succeeded: {1}' -f $TestName,$DnsServer.PingSucceeded) -ForegroundColor Gray

Write-Host ('Testing the connection to the DHCP server') -ForegroundColor Yellow
$DHCPserver = $NIC.DHCPServer
Test-NetConnection -ComputerName $DHCPserver 


try{
  $r = Test-NetConnection -TraceRoute
   
  $r.TcpTestSucceeded
}
catch{
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

