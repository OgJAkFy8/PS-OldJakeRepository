#requires -Version 3.0 -Modules NetTCPIP
BEGIN{
  function Test-NetworkConnection
  {
    param
    (
      [Parameter(Position = 0)]
      [string]$TestName = 'Loopback connection',
    
      [Parameter(Position = 1)]
      [string[]]$TargetNameIp = '127.0.0.1'
    )
    $Delimeter = ':'
    $Formatting = '{0,-23}{1,-2}{2,-24}'

    Write-Verbose -Message $([String]$TargetNameIp)
          
    try
    {
      ForEach($Target in $TargetNameIp) 
      { 
        Write-Host -Object ('Testing {0}:' -f $TestName) -ForegroundColor Yellow
        Write-Verbose -Message $Target 
      
        $TestResults = (Test-NetConnection -ComputerName $Target ).PingSucceeded
        Write-Output -InputObject ($Formatting -f $Target, $Delimeter, $TestResults)
      }
    }
    Catch
    {
      Write-Output -InputObject ('{0} Failed' -f $TestName)
    }
  }
  function Get-WebFacingIPAddress
  {
    param
    (
      [Parameter(Position = 0)]
      [string]$URL = 'http://ipinfo.io/json'
    )
  
    $Delimeter = ':'
    $Formatting = '{0,-23}{1,-2}{2,-24}'
  
    $ExternalIp = Invoke-RestMethod -Uri $URL | Select-Object -ExpandProperty ip
    $NICinfo.ExternalIp = $ExternalIp
  
    Write-Verbose -Message ('This is the IP address you are presenting to the internet')
    Write-Output -InputObject ($Formatting -f 'External IP', $Delimeter, $ExternalIp)
  }
  function Get-NICinformation
  {
    param
    (
      [Parameter(Position = 0)]
      [String]
      $Workstation = 'LocalHost'
    )
    
    $Delimeter = ':'
    $Formatting = '{0,-23}{1,-2}{2,-24}'

    $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation -ErrorAction Stop | Select-Object -Property * -ExcludeProperty IPX*, WINS*
  
    foreach($NIC in $NICs)
    {
      if($NIC.index -eq 1) 
      {
        $NICinfo.DNSHostName          = $NIC.DNSHostName
        $NICinfo.IPAddress            = $NIC.IPAddress[0]
        $NICinfo.DefaultIPGateway     = $NIC.DefaultIPGateway[0]
        $NICinfo.DNSServerSearchOrder = $NIC.DNSServerSearchOrder
        $NICinfo.DHCPServer           = $NIC.DHCPServer
        $NICinfo.IPSubnet             = $NIC.IPSubnet[0]
        $NICinfo.Description          = $NIC.Description
        $NICinfo.MACAddress           = $NIC.MACAddress

        $Script:Description = $NIC.Description
        $Script:DNSHostName = $NIC.DNSHostName
        $Script:IPAddress = $NIC.IPAddress[0]
        $Script:IPSubnet = $NIC.IPSubnet[0]
        $Script:DefaultIPGateway = $NIC.DefaultIPGateway[0]
        $Script:DNSServerSearchOrder = $NIC.DNSServerSearchOrder #[0], $NIC.DNSServerSearchOrder[1]
        $Script:MACAddress = $NIC.MACAddress
      
        if($NIC.DHCPEnabled) 
        {
          $Script:DHCPServer = $NIC.DHCPServer
        }
        Else
        {
          $DHCPServer = 'False'
        }

        Write-Output -InputObject ($Formatting -f 'DNSHostName', $Delimeter, $DNSHostName)
        Write-Output -InputObject ($Formatting -f 'IPAddress', $Delimeter, $IPAddress)
        Write-Output -InputObject ($Formatting -f 'DefaultIPGateway', $Delimeter, $DefaultIPGateway)
        Write-Output -InputObject ($Formatting -f 'DNSServerSearchOrder', $Delimeter, $(([string]$DNSServerSearchOrder).Replace(' ', ', ')))
        Write-Output -InputObject ($Formatting -f 'DHCPEnabled', $Delimeter, $DHCPServer)
        Write-Output -InputObject ($Formatting -f 'IPSubnet', $Delimeter, $IPSubnet)
        Write-Output -InputObject ($Formatting -f 'Description of NIC', $Delimeter, $Description)
        Write-Output -InputObject ($Formatting -f 'MACAddress', $Delimeter, $MACAddress)
      }
    }
  }

    
  $Delimeter = ':'
  $Formatting = '{0,-23}{1,-2}{2,-24}'
  
  $Script:NICinfo = [Ordered]@{
    DNSHostName          = ''
    IPAddress            = ''
    DefaultIPGateway     = ''
    DNSServerSearchOrder = ''
    DHCPServer           = ''
    IPSubnet             = ''
    Description          = ''
    MACAddress           = ''
    ExternalIp           = ''
  }
} 
PROCESS{
  Write-Host -Object ("Gathering the information on your NIC's") -ForegroundColor Yellow
  Get-NICinformation
  
  Write-Host -Object ('Finding the Web facing IP Address') -ForegroundColor Yellow
  Get-WebFacingIPAddress

  Test-NetworkConnection -TestName 'IPAddress' -TargetNameIp $NICinfo['IPAddress'] 
  Test-NetworkConnection -TestName 'DefaultIPGateway' -TargetNameIp $NICinfo['DefaultIPGateway'] 
  Test-NetworkConnection -TestName 'DNSServerSearchOrder' -TargetNameIp $($NICinfo.DNSServerSearchOrder) 
  if($NICinfo.DHCPServer)
  {
    Test-NetworkConnection -TestName 'DHCPServer' -TargetNameIp $NICinfo.DHCPServer
  }
  Test-NetworkConnection -TestName 'ExternalIp' -TargetNameIp $NICinfo['ExternalIp'] 
}
END{
  <#  
      Write-Host -Object ("Local NIC information") -ForegroundColor Cyan
      Write-Output -InputObject ($Formatting -f 'DNSHostName', $Delimeter, $NICinfo.DNSHostName)
      Write-Output -InputObject ($Formatting -f 'IPAddress', $Delimeter, $NICinfo.IPAddress)
      Write-Output -InputObject ($Formatting -f 'DefaultIPGateway', $Delimeter, $NICinfo.DefaultIPGateway)
      Write-Output -InputObject ($Formatting -f 'DNSServerSearchOrder', $Delimeter, $(([string]$NICinfo.DNSServerSearchOrder).Replace(' ', ', ')))
      Write-Output -InputObject ($Formatting -f 'DHCPEnabled', $Delimeter, $NICinfo.DHCPServer)
      Write-Output -InputObject ($Formatting -f 'IPSubnet', $Delimeter, $NICinfo.IPSubnet)
      Write-Output -InputObject ($Formatting -f 'Description of NIC', $Delimeter, $NICinfo.Description)
      Write-Output -InputObject ($Formatting -f 'MACAddress', $Delimeter, $NICinfo.MACAddress)
  #>
}


