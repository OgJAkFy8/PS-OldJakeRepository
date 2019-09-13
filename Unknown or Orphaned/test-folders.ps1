function addfold ($depth,$TargFldr){

# PowerShell Nested Folders
# Set Variables
#$TargFldr# = "c:\Temp\1002"
$tpLevFldr = "TopLev"
$NstFldr = "NestFoldr"
$TstFile = "TestFile"
$i = 0
#$depth = 0


#Param([string]$TargFldr)

Write-Host($TargFldr)


if($depth > 4){
Write-Host("You have put a number larger than 4.  This is going to take a while.")
}

if(!(Test-Path $TargFldr)){
    New-Item -ItemType Directory -Path $TargFldr -Force
    }

Set-Location $TargFldr

While ($i -le $depth) {
$i +=1
Set-Location $TargFldr
New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i -Force
#Set-Location .\$tpLevFldr"-"$i
$j=0
While ($j -le $depth) {
    $j +=1
    #Set-Location .\$tpLevFldr"-"$i
    New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j -Force
    #Set-Location .\$NstFldr"-"$i"-"$j
    $k=0
    While ($k -le $depth) {
        $k+=1
        New-Item -ItemType File -path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j"\"$TstFile"-"$i"-"$j"-"$k".txt" -Force
        }
    }
}
}


function delfold (){
$limit = (Get-Date).AddDays(-0)
$path = "C:\Temp\foldtest"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
}

