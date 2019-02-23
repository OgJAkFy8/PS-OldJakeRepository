#requires -version 3.0

<#
.SYNOPSIS
	Simple script to download the Windows Defender definitions.
.DESCRIPTION
	This script checks the version of the latest against what is available online.  If the versions don't match
    it will download the new version.
.EXAMPLE
	C:\PS> .\Download_Defender.ps1
.NOTES
	Author: Generik
.OUTPUTS
	No output except for the download.
.LINK
	https://github.com/OgJAkFy8/PowerShell_VM-Modules/edit/master/Download_Defender.ps1
#>


# Start Settings

# User Modifications
$Site = "http://go.microsoft.com/fwlink/?LinkID=87341"
$FileName = "mpam-feX64"
$FileExtension = "exe"
$LocalFilePath = "c:\temp\Defender"

# End Settings 

#=======================

# Start Functions 

Function f_tdFileName ($baseNAME, $t){
$t = Get-Date -uformat "%d%H%M%S"
return  $baseNAME + "_" + $t + ".bkp"
}

Function f_verFileName ($baseNAME){
$t = (get-item $baseNAME).VersionInfo.FileVersion
return  $baseNAME + "_" + $t + ".bkp"
}

Function f_FileDownload (){
#Invoke-WebRequest $Site -OutFile $FileDL
}

# End Functions

#=======================

# Begin Script

# Test and create path for download location
if(!(Test-Path $LocalFilePath)){
    Write-Host "Creating Folder"
    New-Item -path $LocalFilePath -ItemType Directory 

    }

# Change the working location
Write-Host "Setting location to $LocalFilePath"
Set-Location $LocalFilePath

# Get file information from Internet
Write-Host "Downloading $FileName file information"
$FileTst = <#Invoke-WebRequest -URI #>$Site 
$OnlineFileVer = $FileTst.versionInfo.FileVersion

$OnlineFileVer = (get-item ".\Copy mpam-feX64 - Copy.exe").versionInfo.FileVersion  #Testing

#Get file information from local file
$LocalFileVer = (Get-Item "$FileName.$FileExtension").versionInfo.FileVersion

<# Test to see if the file exists. Download the file if it does not exist.
If it does exist, it checks to see if the latest version has already been downloaded. #>
if($LocalFileVer -ne $OnlineFileVer){
    Write-Host "Getting New filename"
    $NewName = f_verFileName "$FileName.$FileExtension"

    if (Test-Path "$FileName.$FileExtension"){
        Write-Host "Rename local file"
        Rename-Item "$FileName.$FileExtension" $NewName
        }

    Write-Host "There is an update available.  Starting Download"
    # Invoke-WebRequest $Site -OutFile "$FileName.$FileExtension" 
    }

Write-Host "Finished!"

