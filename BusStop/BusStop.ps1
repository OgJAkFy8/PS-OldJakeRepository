$busseats = 50
$buspeople = $BusStop = 0


while($busseats -gt 0){
$BusStop +=1
$geton = Read-Host 'Enter the amount of people getting on'
$getoff = Read-Host 'Enter the amount of people getting off'

$busseats = $busseats - ($buspeople + ($geton - $getoff))

if($busseats -lt 0){
Write-Output ('The bus is full, {0} need to stay behind' -f $($busseats-50))
$busseats = $busseats-50
}

Write-Host ('Empty Seats: {0} after {1} bus stop.' -f $busseats, $BusStop)


}