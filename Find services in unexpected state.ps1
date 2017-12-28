# Start Settings
# End Settings



<#
Find services in unexpected state
#>

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
