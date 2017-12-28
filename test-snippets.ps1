$Title = "VM Tools Not Up to Date"
$Header = "VM Tools Not Up to Date: [count]"
$Display = "Table"
$Author = "Alan Renouf, Shawn Masterson"
$PluginVersion = 1.1
$PluginCategory = "vSphere"




Write-EventLog –LogName "PS Test Log" –Source “My Script” –EntryType Information –EventID 100 –Message “This is a test message.”

$ArrayList = New-Object -TypeName 'System.Collections.ArrayList';
$Array = @();


Measure-Command
{
for($i = 0; $i -lt 10000; $i++)
{
$null = $ArrayList.Add("Adding item $i")
}
};
Measure-Command
{
for($i = 0; $i -lt 10000; $i++)
{
$Array += "Adding item $i"
}
};


###########################
	

#Have you tried changing the SelectionMode attribute to "One"?

$checkedlistbox2.SelectionMode = "One"

#Alternatively, you could use a radio button control, which allows only one selection at a time? Something like this:

$radioButton1 = New-Object System.Windows.Forms.RadioButton
$radioButton2 = New-Object System.Windows.Forms.RadioButton
$radioButton1.Checked = $True
$radioButton1.Name = "W2K"
$radioButton1.Text = "W2K"
$radioButton1.Location = New-Object System.Drawing.Point(10,10)
$radioButton2.Name = "WXP"
$radioButton2.Text = "WXP"
$radioButton2.Location = New-Object System.Drawing.Point(10,30)
$form.Panel1.Controls.Add($radioButton1)
$form.Panel1.Controls.Add($radioButton2)

###############################

$Services = get-wmiobject win32_service -ErrorAction SilentlyContinue #| Where-Object {$_.DisplayName -like "Win*" }

   $myCol = @()
   Foreach ($service in $Services){
      $MyDetails = "" | select-Object Name, State, StartMode, Health
      If ($service.StartMode -eq "Auto")
      {
         if ($service.State -eq "Stopped")
         {
            $MyDetails.Name = $service.Displayname
            $MyDetails.State = $service.State
            $MyDetails.StartMode = $service.StartMode
            $MyDetails.Health = "Unexpected State"
         }
      }
      If ($service.StartMode -eq "Auto")
      {
         if ($service.State -eq "Running")
         {
            $MyDetails.Name = $service.Displayname
            $MyDetails.State = $service.State
            $MyDetails.StartMode = $service.StartMode
            $MyDetails.Health = "OK"
         }
      }
      If ($service.StartMode -eq "Disabled")
      {
         If ($service.State -eq "Running")
         {
            $MyDetails.Name = $service.Displayname
            $MyDetails.State = $service.State
            $MyDetails.StartMode = $service.StartMode
            $MyDetails.Health = "Unexpected State"
         }
      }
      If ($service.StartMode -eq "Disabled")
      {
         if ($service.State -eq "Stopped")
         {
            $MyDetails.Name = $service.Displayname
            $MyDetails.State = $service.State
            $MyDetails.StartMode = $service.StartMode
            $MyDetails.Health = "OK"
         }
      }
      $myCol += $MyDetails
   }

   $Results = $MyCol | Where-Object {$_.Name -ne $null -and $_.Health -ne "OK"}
   $Results

}

################################################3

# Case Study 1 - Solution with PowerShell 'Switch' Param
Clear-Host
$Disk = Get-WmiObject win32_logicaldisk
Foreach ($Drive in $Disk) {
Switch (14) {
1{ $Drive.DeviceID + " Unknown" }
2{ $Drive.DeviceID + " Floppy or Removable Drive" }
3{ $Drive.DeviceID + " Hard Drive" }
14{ $Drive.DeviceID + " Network Drive" }
5{ $Drive.DeviceID + " CD" }
6{ $Drive.DeviceID + " RAM Disk" }
    }
}


$o = new-object PSObject
$o | add-member NoteProperty PhysicalMemory $PhysicalMemory


$o | export-csv "outputfile.csv" -notypeinformation