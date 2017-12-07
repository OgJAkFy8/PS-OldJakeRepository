<#
This Script migrates all machines to one host so you can reboot the empty one.






#>


# Functions 

function MoveVMsRebootHost($HostOne,$HostTwo){
do{
$servers = get-vm | where {$_.vmhost.name -eq $HostOne}
foreach($server in $servers){
    #Write-Host "Moving $server from $HostOne to $HostTwo"
    move-vm $server -Destination $HostTwo
    }
}while((get-vm | where {$_.vmhost.name -eq $HostOne}).count -ne 0)

if((get-vm | where {$_.vmhost.name -eq $HostOne}).count -eq 0){
    Set-VMHost $HostOne -State Maintenance | Out-Null
    Restart-vmhost $HostOne -confirm:$false | Out-Null  
    }
do {sleep 15
    $ServerState = (get-vmhost $HostOne).ConnectionState
    Write-Host "Shutting Down $HostOne" -ForegroundColor Magenta
    } while ($ServerState -ne "NotResponding")
Write-Host "$HostOne is Down" -ForegroundColor Magenta
    
do {sleep 60
    $ServerState = (get-vmhost $HostOne).ConnectionState
    Write-Host "Waiting for Reboot ..."
    } while($ServerState -ne "Maintenance")
Write-Host "$HostOne back online"
Set-VMHost $HostOne -State Connected | Out-Null 
}

function BalanceVMs (){
$host18 = "214.54.192.18"
$host19 = "214.54.192.19"


$tagged18 = get-vm -tag Host_18
$tagged19 = get-vm -tag Host_19

$servers = Get-VM

foreach($server in $tagged18){
    if($server.vmhost.name -ne $host18){
        Write-Host "Moving $server to Host-18" -ForegroundColor DarkYellow
        move-vm $server -Destination $host18 #-whatif
       }
    }

    foreach($server in $tagged19){
       if($server.vmhost.name -ne $host19){
       Write-Host "Moving $server to Host-19" -ForegroundColor DarkMagenta
       move-vm $server -Destination $host19 #-whatif
        }
    }

}



# Begin Script

#Get list of Norfolk VM's under control of vCenter
$rebootOther = "y"
$balance = "y"
$NorfolkHosts = Get-VMHost | where {$_.name -notlike "214.54.208.*"}

Clear-Host
Write-Host "Welcome to the Reboot and Balance Center" -BackgroundColor Yellow -ForegroundColor DarkBlue
sleep 4
Clear-Host

$NorfolkHosts.name | ft Name
$HostOne = Read-Host "Enter the host IP Address you want to reboot"
$HostTwo = Read-Host "Enter other host"   # $NorfolkHosts.name -ne $HostOne | Out-String
MoveVMsRebootHost $HostOne $HostTwo

$rebootOther = Read-Host "Would you like to reboot the other host [y]/n: "
if($rebootOther -eq "y"){
    MoveVMsRebootHost $HostTwo $HostOne
    }

$balance = Read-Host "Would you like to balance the servers [y]/n: "
if($balance -eq "y"){
    BalanceVMs
    }



