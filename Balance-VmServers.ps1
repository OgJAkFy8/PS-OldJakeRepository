# Assign hosts 
$host18 = '214.54.192.18'
$host19 = '214.54.192.19'

# Get vm's with tags
$tagged18 = get-vm -tag 'host_18'
$tagged19 = get-vm -tag 'host_19'

# Move VM's to hosts based on tags
foreach($server in $tagged18){
    if($server.vmhost.name -ne $host18){
        # Write-Host "Moving $server to Host-18"
        move-vm -name $server -Destination $host18 #-whatif
       }
    }
    
    foreach($server in $tagged19){
       if($server.vmhost.name -ne $host19){
       # Write-Host "Moving $server to Host-19"
       move-vm -name $server -Destination $host19 #-whatif
        }
    }
# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAh/YmKNFWj3jCH+UN+5zDFX3
# 8h6gggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUWJg4DjsWmoBzw8qf63Q4rDWI1x0w
# DQYJKoZIhvcNAQEBBQAEgYAKSYBhtlYLA96GYCPVeiemyv53QN4IgpMMFwIHACwn
# BxpuNs6sCtypjpypSXRrYajUO/u95I4ZMKKk6XmyOneB5gRv0iuS8ZGxll3dmklf
# Wy6t2ME8HaeJ1so3/xg5mvZ5qXAs9hKOYI/4lqDsjeFv7UUOVdZkC89L9TpEadMI
# wg==
# SIG # End signature block
