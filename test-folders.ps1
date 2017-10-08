function addfold (){

# PowerShell Nested Folders
# Set Variables
$TargFldr = "c:\Temp\1001"
$tpLevFldr = "TopLev"
$NstFldr = "NestFoldr"
$TstFile = "TestFile"
$i =0

if(!(Test-Path $TargFldr)){
    New-Item -ItemType Directory -Path $TargFldr -Force
    }

Set-Location $TargFldr

While ($i -le 4) {
$i +=1
Set-Location $TargFldr
New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i -Force
#Set-Location .\$tpLevFldr"-"$i
$j=0
While ($j -le 4) {
    $j +=1
    #Set-Location .\$tpLevFldr"-"$i
    New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j -Force
    #Set-Location .\$NstFldr"-"$i"-"$j
    $k=0
    While ($k -le 4) {
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

