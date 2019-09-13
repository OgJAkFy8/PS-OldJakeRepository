#Download_Defender.ps1

# Functions
#=======================
Function f_tdFileName ($baseNAME){
$t = Get-Date -uformat "%d%H%M%S"
return  $baseNAME + "_" + $t + ".bkp"
}

Function f_verFileName ($baseNAME){
$t = (get-item $baseNAME).VersionInfo.FileVersion
return  $baseNAME + "_" + $t + ".bkp"
}

Function f_FileDownload (){
Invoke-WebRequest $Site -OutFile $FileDL
}
    

# User Modifications
#=======================
$Site = "http://go.microsoft.com/fwlink/?LinkID=87341"
$FileName = "mpam-feX64"
$FileExt = "exe"
$FileLocal = "c:\temp\Defender"



# Begin Script
# =================

# Test and create path for download location
if(!(Test-Path $FileLocal)){
    Write-Host "Creating Folder"
    New-Item -path $FileLocal -ItemType Directory 

    }

# Change the working location
Write-Host "Setting location to $FileLocal"
Set-Location $FileLocal

# Get file information from Internet
Write-Host "Downloading $FileName file information"
#$FileTst = Invoke-WebRequest -URI $Site 
#$OnlineFileVer = $FileTst.versionInfo.FileVersion

$OnlineFileVer = (get-item ".\Copy mpam-feX64 - Copy.exe").versionInfo.FileVersion  #Testing

#Get file information from local file
$LocalFileVer = (Get-Item "$FileName.$FileExt").versionInfo.FileVersion

<# Test to see if the file exists. 
Download it if it does not and test to see if the latest version. #>
if($LocalFileVer -ne $OnlineFileVer){
    Write-Host "Getting New filename"
    $NewName = f_verFileName "$FileName.$FileExt"

    if (Test-Path "$FileName.$FileExt"){
        Write-Host "Rename local file"
        Rename-Item "$FileName.$FileExt" $NewName
        }

    Write-Host "There is an update available.  Starting Download"
    #Invoke-WebRequest $Site -OutFile "$FileName.$FileExt" 
    }

Write-Host "Finished!"

