#requires -Version 3.0

function Test-ServerRolePortGroup 
{
  <#
      .SYNOPSIS
      This function tests for open TCP/UDP ports by server role.

      .DESCRIPTION
      This function tests for all the approprite TCP/UDP ports by server role so you don't have to memorize or look up all of the ports that need to be tested for every time you want to verify remote connectivity on a specific server role.

      .NOTES
      Link port references:
      http://technet.microsoft.com/en-us/library/dd772723(v=ws.10).aspx
      http://en.wikipedia.org/wiki/Server_Message_Block
      http://technet.microsoft.com/en-us/library/cc940063.aspx

      .PARAMETER Computername
      One or more remote, comma-separated computer names

      .PARAMETER ServerRole
      The services on the computer that you'd like to find open ports for. This can be common services like WinRm, Smb, Dns, Active Directory and NetBIOS

      .EXAMPLE
      PS> Test-ServerRolePortGroup -Computername 'LABDC','LABDC2' -ServerRole NetBIOS,WinRm,Dns
		
      This example tests the network ports necessary for NetBIOS, WinRm and Dns to operate on the servers LABDC and LABDC2.
  #>
	
  [CmdletBinding()]
  [OutputType([Management.Automation.PSCustomObject])]
  param (
    [Parameter(Mandatory,HelpMessage = 'At least one server')]
    [ValidateScript({
          Test-Connection -ComputerName $_ -Count 1 -Quiet
    })]
    [string[]]$Computername,
    [Parameter(Mandatory,HelpMessage = "'WinRm','Smb','Dns','ActiveDirectoryGeneral','ActiveDirectoryGlobalCatalog', etc. etc.")]
    [ValidateSet('WinRm','Smb','Dns','ActiveDirectoryGeneral','ActiveDirectoryGlobalCatalog','NetBios')]
    [string[]]$ServerRole
  )
  begin {
    $PortGroups = @{
      'WinRm'                      = @{
        'TCP' = 5985
      }
      'Smb'                        = @{
        'TCP' = 445
        'UDP' = 445
      }
      'Dns'                        = @{
        'TCP' = 53
        'UDP' = 53
      }
      'ActiveDirectoryGeneral'     = @{
        'TCP' = 25, 88, 389, 464, 636, 5722, 9389
        'UDP' = 88, 123, 389, 464
      }
      'ActiveDirectoryGlobalCatalog' = @{
        'TCP' = 3268, 3269
      }
      'NetBios'                    = @{
        'TCP' = 135, 137, 138, 139
        'UDP' = 137, 138, 139
      }
    }
  }
  process {
    foreach ($Computer in $Computername) 
    {
      Write-Verbose -Message ("Beginning port tests on computer '{0}'" -f $Computer)
      try 
      {
        $TestPortGroups = $PortGroups.GetEnumerator() | Where-Object -FilterScript {
          $ServerRole -contains $_.Key
        }
        Write-Verbose -Message ("Found '{0}' port group(s) to test" -f $TestPortGroups.Count)
        foreach ($PortGroup in $TestPortGroups) 
        {
          $PortGroupName = $PortGroup.Key
          $PortGroupValues = $PortGroup.Value
          foreach ($Value in $PortGroupValues.GetEnumerator()) 
          {
            $Protocol = $Value.Key
            $Ports = $Value.Value
            $TestResult = Test-Port -Computername $Computer -Protocol $Protocol -Port $Ports
            $TestResult | Add-Member -MemberType 'NoteProperty' -Name 'PortSet' -Value $PortGroupName
            $TestResult
          }
        }
      }
      catch 
      {
        Write-Host -Message ('{0} - Computer: {1} - Error: {2} - Line Number: {3}' -f $MyInvocation.MyCommand.Name, $Computer, $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
        $false
      }
    }
  }
}

function Test-Port 
{
  <#
      .SYNOPSIS
      This function tests for open TCP/UDP ports.
      .DESCRIPTION
      This function tests any TCP/UDP port to see if it's open or closed.
      .NOTES
      Known Issue: If this function is called within 10-20 consecutively on the same port
      and computer, the UDP port check will output $false when it can be
      $true.  I haven't figured out why it does this.
      .PARAMETER Computername
      One or more remote, comma-separated computer names
      .PARAMETER Port
      One or more comma-separated port numbers you'd like to test.
      .PARAMETER Protocol
      The protocol (UDP or TCP) that you'll be testing
      .PARAMETER TcpTimeout
      The number of milliseconds that the function will wait until declaring
      the TCP port closed.
      .PARAMETER
      The number of millieconds that the function will wait until declaring
      the UDP port closed.
      .EXAMPLE
      PS> Test-Port -Computername 'LABDC','LABDC2' -Protocol TCP 80,443
		
      This example tests the TCP network ports 80 and 443 on both the LABDC
      and LABDC2 servers.
  #>
  [CmdletBinding(DefaultParameterSetName = 'TCP')]
  [OutputType([Management.Automation.PSCustomObject])]
  param (
    [Parameter(Mandatory,HelpMessage = 'One or many computer names')]
    [string[]]$Computername,
    [Parameter(Mandatory,HelpMessage = '80, 443, 53 etc')]
    [int[]]$Port,
    [Parameter(Mandatory,HelpMessage = 'Either TCP or UDP')]
    [ValidateSet('TCP', 'UDP')]
    [string]$Protocol,
    [Parameter(ParameterSetName = 'TCP')]
    [int]$TcpTimeout = 1000,
    [Parameter(ParameterSetName = 'UDP')]
    [int]$UdpTimeout = 1000
  )
  process {
    foreach ($Computer in $Computername) 
    {
      foreach ($Portx in $Port) 
      {
        $Output = @{
          'Computername' = $Computer
          'Port'       = $Portx
          'Protocol'   = $Protocol
          'Result'     = ''
        }
        Write-Verbose -Message ("{0} - Beginning port test on '{1}' on port '{2}<code>:{3}'" -f $MyInvocation.MyCommand.Name, $Computer, $Protocol, $Portx)
        if ($Protocol -eq 'TCP') 
        {
          $TcpClient = New-Object -TypeName System.Net.Sockets.TcpClient
          $Connect = $TcpClient.BeginConnect($Computer, $Portx, $null, $null)
          $Wait = $Connect.AsyncWaitHandle.WaitOne($TcpTimeout, $false)
          if (!$Wait) 
          {
            $TcpClient.Close()
            Write-Verbose -Message ("{0} - '{1}' failed port test on port '{2}</code>:{3}'" -f $MyInvocation.MyCommand.Name, $Computer, $Protocol, $Portx)
            $Output.Result = $false
          }
          else 
          {
            $TcpClient.EndConnect($Connect)
            $TcpClient.Close()
            Write-Verbose -Message ("{0} - '{1}' passed port test on port '{2}<code>:{3}'" -f $MyInvocation.MyCommand.Name, $Computer, $Protocol, $Portx)
            $Output.Result = $true
          }
          $TcpClient.Close()
          $TcpClient.Dispose()
        }
        elseif ($Protocol -eq 'UDP') 
        {
          $UdpClient = New-Object -TypeName System.Net.Sockets.UdpClient
          $UdpClient.Client.ReceiveTimeout = $UdpTimeout
          $UdpClient.Connect($Computer, $Portx)
          Write-Verbose -Message ("{0} - Sending UDP message to computer '{1}' on port '{2}'" -f $MyInvocation.MyCommand.Name, $Computer, $Portx)
          $a = New-Object -TypeName system.text.asciiencoding
          $byte = $a.GetBytes("$(Get-Date)")
          $null = $UdpClient.Send($byte, $byte.length)
          #IPEndPoint object will allow us to read datagrams sent from any source.
          Write-Verbose -Message ('{0} - Creating remote endpoint' -f $MyInvocation.MyCommand.Name)
          $remoteendpoint = New-Object -TypeName system.net.ipendpoint -ArgumentList ([net.ipaddress]::Any, 0)
          try 
          {
            #Blocks until a message returns on this socket from a remote host.
            Write-Verbose -Message ('{0} - Waiting for message return' -f $MyInvocation.MyCommand.Name)
            $receivebytes = $UdpClient.Receive([ref]$remoteendpoint)
            [string]$returndata = $a.GetString($receivebytes)
            If ($returndata) 
            {
              Write-Verbose -Message ("{0} - '{1}' passed port test on port '{2}</code>:{3}'" -f $MyInvocation.MyCommand.Name, $Computer, $Protocol, $Portx)
              $Output.Result = $true
            }
          }
          catch 
          {
            Write-Verbose -Message ("{0} - '{1}' failed port test on port '{2}`:{3}' with error '{4}'" -f $MyInvocation.MyCommand.Name, $Computer, $Protocol, $Portx, $_.Exception.Message)
            $Output.Result = $false
          }
          $UdpClient.Close()
          $UdpClient.Dispose()
        }
        [pscustomobject]$Output
      }
    }
  }
}
