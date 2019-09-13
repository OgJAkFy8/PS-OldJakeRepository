#requires -Version 4.0 -Modules PSDesiredStateConfiguration

<#
Registry [string] #ResourceName
{
    Key = [string]
    ValueName = [string]
    [ Ensure = [string] { Present | Absent }  ]
    [ Force =  [bool]   ]
    [ Hex = [bool] ]
    [ DependsOn = [string[]] ]
    [ ValueData = [string[]] ]
    [ ValueType = [string] { Binary | Dword | ExpandString | MultiString | Qword | String }  ]
}
#>

Configuration ThisCanBeAnyMeaningfulName {
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  
  Node localhost {

    Registry CustomUserSettings {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Microsoft\Office\15.0\User Settings\MyCustomUserSettings'
      ValueName = 'Count'
      ValueData = '1'
    ValueType = 'Dword' }


    Registry BootedRTM {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Microsoft\Office\15.0\User Settings\MyCustomUserSettings\Create\Software\Microsoft\Office\15.0\FirstRun'
      ValueName = 'BootedRTM'
      ValueData = '1'
    ValueType = 'Dword' }

  }
}


ThisCanBeAnyMeaningfulName  -output C:\temp\clientConfig\SetCustomUserSettings 

Start-DscConfiguration -Path C:\temp\clientConfig\SetCustomUserSettings -Wait -Force -Verbose