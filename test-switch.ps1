#[Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'

$SavePath = 'c:\temp\test-switch.csv'
$Boundaries = Import-Csv -Path $SavePath

foreach($Item in $Boundaries)
{
  Switch($item.'BoundaryType')
      {
        
      'IP Subnet' {$Type = 0}
      'Active Directory Site' {$Type = 1}
      'IPv6' {$Type = 2}
      'Ip Address Range' {$Type = 3}

      }
   
  $Arguments = @{DisplayName = $Item.'Display Name'; BoundaryType = $Type; Value = $Item.Value}

  write-host $Arguments[1]
   }