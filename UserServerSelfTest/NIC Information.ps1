#requires -Version 3.0 -Modules NetTCPIP

<#
This is the beginning of the Normal user troubleshooting for when they don't have "the internet".

Plan:
Get the information.  This is everything that we would test such as the gateway, local host and other items that are used for troubleshooting

- Loopback - Hardcode
- Current IP
- Gateway
- External (web facing) ipaddress - Get-WebFacingIPAddress
- Domain Servers
-- DC/Authentication server - $env:logonser
-- DNS
-- DHCP
-- File Server and shares - 
-- 
- User Information
-- Profile Path
-- Local Profile size
-- OST/PST location and Size



Test the information
- Loopback - Test-Connection
- Current IP - Test-Connection
- Gateway - Test-Connection
- Domain Servers
-- DC/Authentication server - Test-Connection
-- DNS - Test-Connection
-- DHCP - Test-Connection
-- File Server and shares - Test-Connection - verify exists
-- 
- User Information
-- Profile Path - verify exists
-- Local Profile size - measure
-- OST/PST location and Size

### Completed Functions or tasks
- External (web facing) ipaddress - Function Get-WebFacingIPAddress -test



#>


##############  
function Get-WebFacingIPAddress
{

  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [Switch]
    $Test
    
  )
  $Delimeter = ':'
  $Output = 'Finding the Web facing IP Address'
  if($Test){
    $Output = 'Finding & testing the Web facing IP Address'
  }
  Write-Host ("`n{0}" -f $Output) -ForegroundColor Yellow
  Write-Verbose ('This is the IP address you are presenting to the internet')
  
  $ExternalIp = Invoke-RestMethod -Uri http://ipinfo.io/json | Select-Object -ExpandProperty ip
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'External IP', $Delimeter, $ExternalIp)
  
  if($Test){
    $ExternalIpTest = Test-NetConnection -ComputerName $ExternalIp
    Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'Ping Succeeded', $Delimeter, $ExternalIpTest.PingSucceeded)
  }
}

#################

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
function Get-NICinformation
{
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [String]
    $Workstation
    
  )
  Write-Host ("Gathering the information on your NIC's") -ForegroundColor Yellow
  $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property * -ExcludeProperty IPX*, WINS* | 
  where Description -NotMatch 'VMnet'
  
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


}
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






##############

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

$TestName = 'Loopback connection'
$TargetName = '127.0.0.1'
Write-Host ("Testing $TestName") -ForegroundColor Yellow
$TestResults = Test-NetConnection -ComputerName $TargetName 
Write-Host ('Loopback Interface Alias:  {0}' -f $TestResults.InterfaceAlias) -ForegroundColor Gray
$TestNameCount = ($TestName.Length + 7)
Write-Host ("{0,-$TestNameCount} {1,-2}{2,-24}" -f $TestName,': Passed ',$TestResults.PingSucceeded) -ForegroundColor Gray

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

