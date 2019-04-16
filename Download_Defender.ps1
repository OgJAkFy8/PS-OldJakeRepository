#Download_Defender.ps1


This does not appear to work. 


Function Get-DefenderDownload
{
  <#
      .SYNOPSIS
      Describe purpose of "Get-DefenderDownload" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Get-DefenderDownload
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Get-DefenderDownload

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
  # User Modifications
  #=======================
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]$baseNAME,
    # $Site = 'http://go.microsoft.com/fwlink/?LinkID=87341',
    [string]$Site = 'https://github.com/KnarrStudio/PS-Scripts/archive/master.zip',
    [string]$FileName = 'master',
    [string]$FileExt = 'zip',
    [string]$FileLocal = "$env:HOMEDRIVE\temp\Defender"
  )
  Enable-Tls -Tls12

  # Functions
  #=======================
  Function Get-tdFileName
  {
    param
    (
      [Parameter(Mandatory)]$baseNAME
    )
    $t = Get-Date -UFormat '%d%H%M%S'
    return  $baseNAME + '_' + $t + '.bkp'
  }

  Function Get-verFileName
  {
    param
    (
      [Parameter(Mandatory)]$baseNAME
    )
    $t = (Get-Item -Path $baseNAME).VersionInfo.FileVersion
    return  $baseNAME + '_' + $t + '.bkp'
  }
  #Get-verFileName $FileDL

  Function Get-tstFile
  {
    param
    (
      [Parameter(Mandatory)]$TestFileName
    )
  }

  Function Get-FileDownload ()
  {
    Invoke-WebRequest -Uri $Site -OutFile $FileDL -Method GET 
  }
    



  # Begin Script
  # =================

  # Test and create path for download location
  if(!(Test-Path -Path $FileLocal))
  {
    Write-Verbose -Message 'Creating Folder'
    New-Item -Path $FileLocal -ItemType Directory
  }

  # Change the working location
  Write-Verbose -Message ('Setting location to {0}' -f $FileLocal)
  Set-Location -Path $FileLocal

  # Get file information from Internet
  Write-Verbose -Message ('Downloading {0} file information' -f $FileName)
  $FileTst = Invoke-WebRequest -URI $Site 
  $OnlineFileVer = $FileTst.versionInfo.FileVersion

  $OnlineFileVer = (Get-Item -Path '.\Copy mpam-feX64 - Copy.exe').versionInfo.FileVersion  #Testing

  #Get file information from local file
  $LocalFileVer = (Get-Item -Path ('{0}.{1}' -f $FileName, $FileExt)).versionInfo.FileVersion

  <# Test to see if the file exists. 
  Download it if it does not and test to see if the latest version. #>
  if($LocalFileVer -ne $OnlineFileVer)
  {
    Write-Verbose -Message 'Getting New filename'
    $NewName = Get-verFileName -baseNAME ('{0}.{1}' -f $FileName, $FileExt)

    if (Test-Path -Path ('{0}.{1}' -f $FileName, $FileExt))
    {
      Write-Verbose -Message 'Rename local file'
      Rename-Item -Path ('{0}.{1}' -f $FileName, $FileExt) -NewName $NewName
    }

    Write-Verbose -Message 'There is an update available.  Starting Download'
    #Invoke-WebRequest $Site -OutFile "$FileName.$FileExt" 
  }

  Write-Host 'Finished!'
}

Get-DefenderDownload -Verbose