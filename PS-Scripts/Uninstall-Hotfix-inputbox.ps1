function Uninstall-Hotfix {
[cmdletbinding()]
param(
$computername = $env:computername,
[string] $HotfixID
)            

$hotfixes = Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering | select hotfixid            

if($hotfixes -match $hotfixID) {
    $hotfixID = $HotfixID.Replace("KB","")
    Write-host "Found the hotfix KB" + $HotfixID
    Write-Host "Uninstalling the hotfix"
    $UninstallString = "cmd.exe /c wusa.exe /uninstall /KB:$hotfixID /quiet /norestart"
    ([WMICLASS]"\\$computername\ROOT\CIMV2:win32_process").Create($UninstallString) | out-null            

    while (@(Get-Process wusa -computername $computername -ErrorAction SilentlyContinue).Count -ne 0) {
        Start-Sleep 3
        Write-Host "Waiting for update removal to finish ..."
    }
write-host "Completed the uninstallation of $hotfixID"
}
else {            

write-host "Given hotfix($hotfixID) not found"
return
}            

}

#requires -Version 2
function Show-InputBox
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Prompt,
        
        [Parameter(Mandatory=$false)]
        [string]
        $DefaultValue='',
        
        [Parameter(Mandatory=$false)]
        [string]
        $Title = 'Windows PowerShell',

        [Parameter(Mandatory=$false)]
        [string]
        $a = ''
    )
    
    
    Add-Type -AssemblyName Microsoft.VisualBasic
    [Microsoft.VisualBasic.Interaction]::InputBox($Prompt,$Title, $DefaultValue)
}

Show-InputBox "Enter KB" | Uninstall-Hotfix -computername "D114067"
