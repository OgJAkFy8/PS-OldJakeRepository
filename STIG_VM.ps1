<# 
With the exception of removing VM devices (EG Floppy Drive) which reuqire the VM to be powered off,this script sets all STIG settings for a Virtual machine. 
It utilizes the stig_vm.csv to set them. It has the capability to run against one VM or all VMs located on a host. When conducting all VMs the script will do one STIG against all VMs and then proceeds onto the next.It will also produce an output file when accomplishing all tasks.
#>

# Set input output files
$stig_vm = Import-CSV ".\stig_vm.csv" -Header Name,Value
$Output = ".\STIG_ALL_VMs.csv"

# APPLY TO JUST VN_NAME
Clear-Host
$VM_NAME = Read-Host("EnterServerName or all: ")
#Write-Host($VM_NAME)

If($VM_NAME -ne "all") {
    foreach ($line in $stig_vm) {
        New-AdvancedSetting -Entity $VM_NAME -Name ($line.Name) -value($line.value) -Force -Confirm:$false | Select Entity, Name, Value}
        Write-Host("if")
}
else{
# APPLY TO ALL VM
#$AllVMS = get-vm | where PowerState -EQ "poweredon"
foreach ($line in $stig_vm) {
    (get-vm | where PowerState -EQ "poweredon") | New-AdvancedSetting -Name ($line.Name) -value($line.value) -Force -Confirm:$false | Select Entity, Name, Value | Export-CSV $output}
    Write-Host("else")
}