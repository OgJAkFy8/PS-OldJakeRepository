# Begin Script
# ========================



$t = split-path $PSCommandPath -Parent
set-location $t
.\DeleteFilesOlder.ps1


if ($asAdmin -ne $true){

# Set working and log location
f_make-filefold $workingLocation "folder"
Set-Location $workingLocation

# Set name of file
f_make-filefold $Logfile "file"
$Script:Outputfile = $Logfile


# Math
$Script:limit = (Get-Date).AddDays(-$dayLimit)
$Script:fileCount = f_fileMath "cnt"

# Test if there are files to be deleted
if ($fileCount -gt 5){
    $strtTime = Get-Date #f_TimeStamp
    f_serviceControl $Service "stop"
    f_deleteFileFold
    f_serviceControl $Service "start"
    $stopTime = Get-Date # f_TimeStamp
    f_Output $Outputfile $strtTime $stopTime
    Write-Host "Job Completed!  View Log: $workingLocation\$Logfile" -ForegroundColor White -BackgroundColor DarkGreen

}
}


else{
Write-Host "*** Re-run as an administrator ******" -ForegroundColor Black -BackgroundColor Yellow
}
