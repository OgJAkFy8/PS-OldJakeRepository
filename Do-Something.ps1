Function Remove-COOPs {
	<#
.SYNOPSIS
Describe the function here
.DESCRIPTION
Describe the function in more detail
.EXAMPLE
Give an example of how to use it
.EXAMPLE
Give another example of how to use it
.PARAMETER computername
The computer name to query. Just one.
.PARAMETER logname
The name of a file to write failed computer names to. Defaults to errors.txt.
#>

[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='high')]
param
(
	[Parameter(Mandatory=$True,
		ValueFromPipeline=$True,
		ValueFromPipelineByPropertyName=$True,
		HelpMessage='What VM  would you like to target?')]
	[Alias('vm')]
	[ValidateLength(3,30)]
	[string[]]$computername,

	[string]$logname = 'errors.txt'
)

begin {
	write-verbose "Deleting $logname"
	del $logname -ErrorActionSilentlyContinue
}

process {

	write-verbose "Beginning process loop"

	foreach ($computer in $computername) {
		Write-Verbose "Processing $computer"
		if ($pscmdlet.ShouldProcess($computer)) {
			# use $computer here
		}
	}
}
	if ($MainMenuChoice -eq '2'){Clear-Host}

	#Get List of all VM's with "COOP" in the name. This will be used as the list of COOP's that will be deleted.
	$VMServers = get-vm | Where-Object {$_.Name -match 'COOP'}
	$VMServers | Format-Table Name

	#Enter the date of the COOP vms that you want to remove.  From the printout of the list above, you will be able to select the unwanted dates.
	$COOPdate = Read-Host 'Enter the date of the COOP you want to remove (YYYYMMDD) '

	#Get List of the VM Clones you want to Remove.  This is similar to the first step, but uses the specific date you gave to search on.  This will be your list of systems to remove.
	$PoweredOffClones = $VMPoweredOff | Where-Object -FilterScript {$_.Name -like "$COOPdate*"} #| ft Name, ResourcePool  -AutoSize

	#Set "$OkRemove" to "N" 
	$OkRemove = 'N'
	$OkRemove = Read-host "Preparing to remove ALL COOP'ed vm servers below. $PoweredOffClones`nIs this Okay? [N] "

	If ($OkRemove -eq 'Y'){
		#Remove older COOP's from the list you created in the early part of the script.
		foreach ($VMz in $PoweredOffClones) {
			Write-Host -sep `n "Checking to ensure $VMz is Powered Off." #-foregroundcolor Red
			If (($VMz.PowerState -eq 'PoweredOff') -and ($VMz.Name -match 'COOP')){
				Write-Host -sep `n $VMz 'is in a Powered Off state and will be removed. ' -foregroundcolor Blue 
				#Write-Host "Remove-VM $VMz -DeletePermanently -confirm:$true "
				Remove-VM $VMz -DeletePermanently -confirm:$true -runasync 

			}}}
}}
# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZGgQ0N4JepdCq58LNSRKua79
# /VagggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
# MBYxFDASBgNVBAMTC0VyaWtBcm5lc2VuMB4XDTE3MTIyOTA1MDU1NVoXDTM5MTIz
# MTIzNTk1OVowFjEUMBIGA1UEAxMLRXJpa0FybmVzZW4wgZ8wDQYJKoZIhvcNAQEB
# BQADgY0AMIGJAoGBAKYEBA0nxXibNWtrLb8GZ/mDFF6I7tG4am2hs2Z7NHYcJPwY
# CxCw5v9xTbCiiVcPvpBl7Vr4I2eR/ZF5GN88XzJNAeELbJHJdfcCvhgNLK/F4DFp
# kvf2qUb6l/ayLvpBBg6lcFskhKG1vbEz+uNrg4se8pxecJ24Ln3IrxfR2o+BAgMB
# AAGjYDBeMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEcGA1UdAQRAMD6AEMry1NzZravR
# UsYVhyFVVoyhGDAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlboIQyWSKL3Rtw7JMh5kR
# I2JlijAJBgUrDgMCHQUAA4GBAF9beeNarhSMJBRL5idYsFZCvMNeLpr3n9fjauAC
# CDB6C+V3PQOvHXXxUqYmzZpkOPpu38TCZvBuBUchvqKRmhKARANLQt0gKBo8nf4b
# OXpOjdXnLeI2t8SSFRltmhw8TiZEpZR1lCq9123A3LDFN94g7I7DYxY1Kp5FCBds
# fJ/uMYIBSjCCAUYCAQEwKjAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlbgIQyWSKL3Rt
# w7JMh5kRI2JlijAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUPhKnWheRwyYNND+2jUaAOBnVdEQw
# DQYJKoZIhvcNAQEBBQAEgYCKnvszAHL3G3SIm5bDFa6nit7XvJGtrp3pvS5D1cfo
# Pw3LR1OwpAJSJKL7extd82P+n8eGFCa+N2eN3ebZWdwx3p6tlgi2s+eHz3FpNf+w
# YuDrFczWk9bRgQyUUYpAaIHSF1sAh0vT7jnz+2T4OkZI3LepqkATZJ6dVe39f5dz
# 1w==
# SIG # End signature block
