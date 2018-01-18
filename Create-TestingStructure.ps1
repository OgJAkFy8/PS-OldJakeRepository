

function script:Add-TestFolders{
<#
.SYNOPSIS
    This is a simple Powershell script to create a group of nested folders. 
    The depth is decided by the number you pass.
.DESCRIPTION
    The function will create a group of nested folders for testing other scripts.
.EXAMPLE
    Add-TestFolders 2 

.NOTES
    Script Name: test-folders.ps1
    Author Name: Erik
    Date: 10/5/2017
    Contact : 
.LINK
     PowerShell_VM-Modules/Create-TestingStructure.ps1 

function test-set {
    [CmdletBinding(DefaultParameterSetName = 3)]
    param(
        [parameter(mandatory=$true, parametersetname="FooSet")]
        [switch]$FldrDpth,[parameter(mandatory=$true,position=0,parametersetname="Folder Depth")]
        [string]$TargFldr,[parameter(mandatory=$true,position=1)]
        [io.fileinfo]$FilePath)
@"
  Parameterset is: {0}
  Bar is: '{1}'
  -TargFldr present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $FldrDpt, $TargFldr.IsPresent, $FilePath
}
#>

  [CmdletBinding(
      DefaultParameterSetName = 'TargetFolder', 
    SupportsShouldProcess)]



    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
    [Alias('Folder Depth')]
    [Int]$FolderDepth,
    [Int]$FolderAmount = 40,
    [STRING]$TargFldr = 'c:\Temp\TestingFolders',
    [STRING]$tpLevFldr = 'TopLev',
    [STRING]$NstFldr = 'NestFoldr',
    [STRING]$TstFile = 'TestFile'
    )

    WRITE-DEBUG -Message ("`$TargFldr: {0}" -f $TargFldr)
    WRITE-DEBUG -Message ("`$tpLevFldr: {0}" -f $tpLevFldr)
    WRITE-DEBUG -Message ("`$NstFldr: {0}" -f $NstFldr)


  @"
  Parameterset is: {0}
  Bar is: '{1}'
  -TargFldr present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $FolderDepth, $TargFldr.IsPresent, $FilePath



            $i=1
            Do {
                $TargFldr = "c:\Temp\TestingFolders\NestedFolders-$i"
                $i++
                }while (Test-Path $TargFldr)



  # PowerShell Nested Folders
  # Set Variables
  #$FolderDepth = 3
  #$TargFldr = "c:\Temp\1001"
  #$tpLevFldr = "TopLev"
  #$NstFldr = "NestFoldr"
  #$TstFile = "TestFile"
  $i = 0

  if(!(Test-Path $TargFldr)){
    New-Item -ItemType Directory -Path $TargFldr -Force
    }

  Set-Location $TargFldr

  While ($i -le $FolderDepth) {
    $i +=1
    Set-Location $TargFldr
    New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i -Force
    #Set-Location .\$tpLevFldr"-"$i
    $j=0
    While ($j -le $FolderDepth) {
      $j +=1
      #Set-Location .\$tpLevFldr"-"$i
      New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j -Force
      #Set-Location .\$NstFldr"-"$i"-"$j
      $k=0
      While ($k -le $FolderDepth) {
        $k+=1
        #New-Item -ItemType File -path 
        New-EmptyFile $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j"\"$TstFile"-"$i"-"$j"-"$k".txt" $FolderDepth # -Force
        }
    }
  }
}



function New-EmptyFile
{
   param( [string]$FilePath,[double]$Size )
 
   $file = [System.IO.File]::Create($FilePath)
   $file.SetLength($Size*1024)
   $file.Close()
   Get-Item $file.Name
}


function Remove-TestFolders (){
  $limit = (Get-Date).AddDays(-0)
  Set-Location 'C:\Temp\TestingFolders'

$NestedFolders = Get-ChildItem | Where-Object{$_.Name -match 'NestedFolders'} | Sort-Object -Property $_.Lastwritetime
$menu = @{}
$folderCount = $NestedFolders.Count-1

for($i = 0;$i -lt $NestedFolders.count;$i++){
  Write-Host ('{0}. {1}' -f $i, $NestedFolders[$i].name)
  $menu.Add($i,($NestedFolders[$i].name))
}

do{[int]$ans = Read-Host -Prompt 'Select number to Remove'
  if($ans -ge $folderCount ){
    Write-Host ('Select a number between 0 and {0}' -f $folderCount)
  }
}until($ans -in 0..$folderCount)

$selection = $menu.Item($ans)
  
  #$folder = Read-Host "Enter Folder Name"
  $path = Resolve-Path $selection
 $ans = 3
 $ans = Read-Host -Prompt "`n1-Delete Files`n2) Delete Folders and Files (All)`n[3].Exit"
 
  # Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | 
  Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | 
  Remove-Item -Force -WhatIf

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | 
  Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | 
  Where-Object { !$_.PSIsContainer }) -eq $null } | 
  Remove-Item -Force -Recurse -WhatIf
}


## Begin script

Write-Host "Options `nAdd-TestFolders`nRemove-TestFolders"



