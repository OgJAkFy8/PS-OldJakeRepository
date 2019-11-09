#requires -Version 2.0
$Sites = 'www.google.com', 'rsrcnfs08', 'www.bing.com', 'www.youtube.com', 'www.cnn.com', 'www.facebook.com', 'www.yahoo.com', 'www.washingtonpost.com', 'rsrcnepo59mc'

function Test-UnderseaFiber
{
  <#
      .SYNOPSIS
      Describe purpose of "Test-UnderseaFiber" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER Sites
      Describe parameter -Sites.

      .EXAMPLE
      Test-UnderseaFiber -Sites Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Test-UnderseaFiber

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>



  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'One or many sites or hosts')]
    [String[]]
    $Sites
  )
  $verboseOutput = 'Although not always the case this could indicate that you are on the backup circuit'
  ForEach($Site in $Sites)
  {
    try
    {
      $TestResponse = Test-Connection -ComputerName $Site -Count 1 -ErrorAction Stop
    }
    catch
    {
      Write-Host ('Testing connection to computer {0} failed: No such host is known' -f $Site ) -ForegroundColor DarkYellow
    }
    $RTT = $TestResponse.ResponseTime
    
    if($RTT -gt 300)
    {
      Write-Host ('{0,-24} RoundTripTime is {1} ms.  {2,10}' -f $TestResponse.Address, $RTT, 'Poor') -ForegroundColor Red
      Write-Verbose -Message ('{0} {1}.' -f $verboseOutput, 'Satellite')
    }
    ElseIf($RTT -gt 90)
    {
      Write-Host ('{0,-24} RoundTripTime is {1} ms.  {2,10} ' -f $TestResponse.Address, $RTT, 'Okay') -ForegroundColor Yellow
      Write-Verbose -Message ('{0} {1}.' -f $verboseOutput, 'Puerto Rico') 
    }
    ElseIf($RTT -gt 0)
    {
      Write-Host ('{0,-24} RoundTripTime is {1} ms.  {2,10} ' -f $TestResponse.Address, $RTT, 'Good') -ForegroundColor Green
      Write-Verbose -Message ('{0} {1}.' -f 'The average RTT should be about', '45 - 52ms')
    }
  }
}

Test-UnderseaFiber -Sites $Sites -Verbose
