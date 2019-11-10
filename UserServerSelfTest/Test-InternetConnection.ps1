#requires -Version 3.0 -Modules NetTCPIP
function Get-WebFacingIPAddress
{
  param
  (
    [Parameter(Mandatory = $false, Position = 0)]
    [Switch]
    $Test
    
  )
  $Delimeter = ':'
  $Output = 'Finding the Web facing IP Address'
  if($Test)
  {
    $Output = 'Finding & testing the Web facing IP Address'
  }
  Write-Host ("`n{0}" -f $Output) -ForegroundColor Yellow
  Write-Verbose -Message ('This is the IP address you are presenting to the internet')
  
  $ExternalIp = Invoke-RestMethod -Uri http://ipinfo.io/json | Select-Object -ExpandProperty ip
  Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'External IP', $Delimeter, $ExternalIp)
  
  if($Test)
  {
    $ExternalIpTest = Test-NetConnection -ComputerName $ExternalIp
    Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'Ping Succeeded', $Delimeter, $ExternalIpTest.PingSucceeded)
  }
}

function Get-NICinformation
{
  param
  (
    [Parameter(Mandatory = $false, Position = 0)]
    [String]
    $Workstation = 'LocalHost'
  )
  Write-Host ("Gathering the information on your NIC's") -ForegroundColor Yellow
  $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property * -ExcludeProperty IPX*, WINS*
  
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
    if(!($NIC.DHCPEnabled))
    {
      Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'DHCPServer', $Delimeter, $NIC.DHCPServer)
    }
    Write-Output -InputObject ('{0,-23}{1,-2}{2,-24}' -f 'MACAddress', $Delimeter, $NIC.MACAddress)
  }
}
function Test-NetworkConnection
{
  param
  (
    [Parameter(Mandatory = $false, Position = 0)]
    [string]
    $TestName = 'Loopback connection',
    
    [Parameter(Mandatory = $false, Position = 1)]
    [string]
    $TargetNameIp = '127.0.0.1'
  )

  $TestMsg = [PSCustomObject]@{
    DNSHostName      = 'Testing DNS'
    DHCPServer       = 'Testing the connection to the DHCP server'
    DefaultIPGateway = 'Testing the Gateway connection'
    Loopback         = 'Testing the Loopback connection'
  }
  try
  {
    Write-Host ('Testing {0}' -f $TestName) -ForegroundColor Yellow
  

    $TestResults = Test-NetConnection -ComputerName $TargetNameIp 
    $TestNameCount = [int]($TestName.Length + 7)
    #$TestNameCount
    Write-Host ("{0,-$TestNameCount}{1,-2}{2,-24}" -f  $TargetNameIp, ':   Passed = ', $TestResults.PingSucceeded) -ForegroundColor Gray
    #Write-Host ('Testing - {0}{1}{2}' -f  $TargetNameIp,':   Passed ',$TestResults.PingSucceeded) -ForegroundColor Gray
  }
  Catch
  {
    Write-Host ('Testing {0}' -f $TestName) -ForegroundColor Yellow
    Write-Host ('{0} Failed' -f $TestName) -ForegroundColor Red
  }
}

function Test-IpConnection
{
  param
  (
    [Parameter(Mandatory = $false, Position = 0)]
    [String[]]$ComputerName
  )
  
  $NICinfo = [PSCustomObject]@{
    DefaultIPGateway = $NIC.DefaultIPGateway
    DHCPServer       = $NIC.DHCPServer
    IPAddress        = $NIC.IPAddress
    DNSHostName      = $NIC.DNSHostName
  }

  $TestMessage = [PSCustomObject]@{
    DNSHostName      = 'Testing DNS'
    DHCPServer       = 'Testing the connection to the DHCP server'
    DefaultIPGateway = 'Testing the Gateway connection'
    Loopback         = 'Testing the Loopback connection'
  }
  (Test-NetConnection -ComputerName $ComputerName)
  
  Write-Host ('{0,-23}{1,-2}{2,-24}' -f $TestMessage., 2, 3) -ForegroundColor Yellow
  Write-Host ('{0,-23}{1,-2}{2,-24}' -f 1, 2, 3) -ForegroundColor Gray
  Write-Host ('{0,-23}{1,-2}{2,-24}' -f 1, 2, 3) -ForegroundColor Gray
}

function Test-NICstatus
{
  $NICinfo = [PSCustomObject]@{
    DefaultIPGateway = $NIC.DefaultIPGateway
    DHCPServer       = $NIC.DHCPServer
    IPAddress        = $NIC.IPAddress
    DNSHostName      = $NIC.DNSHostName
  }
  $TestMessage = [PSCustomObject]@{
    DNSHostName      = 'Testing DNS'
    DHCPServer       = 'Testing the connection to the DHCP server'
    DefaultIPGateway = 'Testing the Gateway connection'
    Loopback         = 'Testing the Loopback connection'
  }

  <#  Write-Host ('Testing the Loopback connection') -ForegroundColor Yellow
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
  Write-Host ('{0} Ping Succeeded: {1}' -f $TestName,$DnsServer.PingSucceeded) -ForegroundColor Gray#>
  
  Write-Host ("Testing the $NICinfo.DefaultIPGateway - $($NICinfo.DefaultIPGateway) connection") -ForegroundColor Yellow
  $DnsServer = Test-NetConnection -ComputerName $($NICinfo.DefaultIPGateway)
  Write-Host ('Loopback Interface Alias:  {0}' -f $DnsServer.InterfaceAlias) -ForegroundColor Gray
  Write-Host ('{0} Ping Succeeded: {1}' -f $($TestMessage.DefaultIPGateway), $DnsServer.PingSucceeded) -ForegroundColor Gray

  Write-Host ('Testing the connection to the DHCP server') -ForegroundColor Yellow
  $DHCPserver = $NIC.DHCPServer
  Test-NetConnection -ComputerName $DHCPserver 
}


Get-NICinformation -Workstation localhost
Get-WebFacingIPAddress -Test
Test-NetworkConnection -TestName 'Outside Yahoo' -TargetNameIp www.yahoo.com
Test-NetworkConnection -TestName DHCPServer -TargetNameIp 192.168.1.222

Test-IpConnection -ComputerName 192.168.1.3
Test-NICstatus 192.168.1.3