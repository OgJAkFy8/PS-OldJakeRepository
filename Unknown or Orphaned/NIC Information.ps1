$lenovo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Workstation | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

$lenovo.MACAddress

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | where{$_.IPEnabled -eq “TRUE”}
Foreach($NIC in $NICs) {
$NIC.EnableDHCP()
$NIC.SetDNSServerSearchOrder()
}