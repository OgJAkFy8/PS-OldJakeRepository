#requires -Version 1.0
[int]$Seats = 0
[int]$BusStop = 0
[int]$Passengers = 0

while($Seats -lt 49)
{
  $BusStop += 1

  if($BusStop -gt 1)
  {
    [int]$Passengers = Read-Host -Prompt 'Enter the amount of people getting off'
    $Seats = $Seats - $Passengers
  }
  [int]$Passengers = Read-Host -Prompt 'Enter the amount of people getting on'
  $Seats = $Seats + $Passengers
  if($Seats -gt 50)
  {
    Write-Host -Object ('Bus is full {0} need to stay behind.' -f ($Seats - 50))
    $Seats = $Seats - $($Seats - 50)
  }

  Write-Host -Object ('Empty Seats: {0} after {1} bus stop.' -f $(50 - $Seats), $BusStop)
}
