#requires -Version 4.0 -Modules PSDesiredStateConfiguration

Configuration Add-WsusSettings {
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  
  Node localhost {

    Registry EnableAcceptTrustedPublisherCerts {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'AcceptTrustedPublisherCerts'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableElevateNonAdmins {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'ElevateNonAdmins'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry SetTargetGroup {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'TargetGroup'
      ValueData = 'Workstations'
    ValueType = 'String' }

    Registry EnableTargetGroupEnabled {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'TargetGroupEnabled'
      ValueData = '0'
    ValueType = 'Dword' }

    Registry SetWUServer {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'WUServer'
      ValueData = 'http://2012-host/:80'
    ValueType = 'String' }

    Registry SetWUStatusServer {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
      ValueName = 'WUStatusServer'
      ValueData = 'http://2012-host/:80'
    ValueType = 'String' }

    Registry SetAUOptions {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'AUOptions'
      ValueData = '4'
    ValueType = 'Dword' }

    Registry EnableAUPowerManagements {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'AUPowerManagement'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableAutoInstallMinorUpdates {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'AutoInstallMinorUpdates'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry SetDetectionFrequency {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'DetectionFrequency'
      ValueData = '10'
    ValueType = 'Dword' }

    Registry EnableDetectionFrequencyEnabled {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'DetectionFrequencyEnabled'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableIncludeRecommendedUpdates {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'IncludeRecommendedUpdates'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableNoAUAsDefaultShutdownOption {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'NoAUAsDefaultShutdownOption'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableNoAUShutdownOption {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'NoAUShutdownOption'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry EnableNoAutoRebootWithLoggedOnUsers {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'NoAutoRebootWithLoggedOnUsers'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry DisableNoAutoUpdate {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'NoAutoUpdate'
      ValueData = '0'
    ValueType = 'Dword' }

    Registry SetRebootRelaunchTimeout {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'RebootRelaunchTimeout'
      ValueData = '10'
    ValueType = 'Dword' }

    Registry EnableRebootRelaunchTimeoutEnabled {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'RebootRelaunchTimeoutEnabled'
      ValueData = '1'
    ValueType = 'Dword' }

    Registry SetRescheduleWaitTime {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'RescheduleWaitTime'
      ValueData = '10'
    ValueType = 'Dword' }

    Registry SetScheduledInstallDay {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'ScheduledInstallDay'
      ValueData = '0'
    ValueType = 'Dword' }

    Registry SetScheduledInstallTime {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'ScheduledInstallTime'
      ValueData = '3'
    ValueType = 'Dword' }

    Registry EnableUseWUServer {
      Ensure = 'Present'
      Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
      ValueName = 'UseWUServer'
      ValueData = '1'
    ValueType = 'Dword' }

  }
}


Add-WsusSettings  -output C:\temp\Add-WsusSettings

Start-DscConfiguration -Path C:\temp\Add-WsusSettings  -Wait -Force -Verbose