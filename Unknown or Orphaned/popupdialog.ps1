# $ErrorActionPreference = 'stop'

# add a helper
$showWindowAsync = Add-Type –memberDefinition @” 
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

$myCred = get-Credential

Import-Module ActiveDirectory

function Hide-PowerShell() { 
    [void]$showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 2) 
}

# WARNINGS #########################################################################
function warn 
{

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $warn = New-Object System.Windows.Forms.Form 
    $warn.Text = "Error"
    $warn.Size = New-Object System.Drawing.Size(400,200) 
    $warn.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
    $warn.Font = $font

    $wtext = New-Object System.Windows.Forms.Label
    $wtext.Location = New-Object System.Drawing.Point(40,30) 
    $wtext.Size = New-Object System.Drawing.Size(550,50) 
    $wtext.Text = "Username Can't be Null or Empty"
    $warn.Controls.Add($wtext) 

    $wButton = New-Object System.Windows.Forms.Button
    $wButton.Location = New-Object System.Drawing.Point(140,80)
    $wButton.Size = New-Object System.Drawing.Size(100,50)
    $wButton.Text = "OK"
    $wButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $warn.AcceptButton = $wButton
    $warn.Controls.Add($wButton)

    $warn.Topmost = $False
    $warn.FormBorderStyle = 'Fixed3D'
    $warn.MaximizeBox = $false
    $warn.MinimizeBox = $false
    $wresult = $warn.ShowDialog()
}

function warn2 
{

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $warn2 = New-Object System.Windows.Forms.Form 
    $warn2.Text = "Error"
    $warn2.Size = New-Object System.Drawing.Size(400,200) 
    $warn2.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
    $warn2.Font = $font

    $wtext2 = New-Object System.Windows.Forms.Label
    $wtext2.Location = New-Object System.Drawing.Point(90,30) 
    $wtext2.Size = New-Object System.Drawing.Size(550,50) 
    $wtext2.Text = "This account is not locked"
    $warn2.Controls.Add($wtext2) 

    $wButton2 = New-Object System.Windows.Forms.Button
    $wButton2.Location = New-Object System.Drawing.Point(140,80)
    $wButton2.Size = New-Object System.Drawing.Size(100,50)
    $wButton2.Text = "OK"
    $wButton2.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $warn2.AcceptButton = $wButton2
    $warn2.Controls.Add($wButton2)

    $warn2.Topmost = $False
    $warn2.FormBorderStyle = 'Fixed3D'
    $warn2.MaximizeBox = $false
    $warn2.MinimizeBox = $false
    $wresult2 = $warn2.ShowDialog()
}

function warn3 
{

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $warn3 = New-Object System.Windows.Forms.Form 
    $warn3.Text = "Error"
    $warn3.Size = New-Object System.Drawing.Size(400,200) 
    $warn3.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
    $warn3.Font = $font

    $wtext3 = New-Object System.Windows.Forms.Label
    $wtext3.Location = New-Object System.Drawing.Point(40,30) 
    $wtext3.Size = New-Object System.Drawing.Size(550,50) 
    $wtext3.Text = "An error occured:"
    $warn3.Controls.Add($wtext3) 

    $wButton3 = New-Object System.Windows.Forms.Button
    $wButton3.Location = New-Object System.Drawing.Point(140,80)
    $wButton3.Size = New-Object System.Drawing.Size(100,50)
    $wButton3.Text = "OK"
    $wButton3.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $warn3.AcceptButton = $wButton3
    $warn3.Controls.Add($wButton3)

    $warn3.Topmost = $False
    $warn3.FormBorderStyle = 'Fixed3D'
    $warn3.MaximizeBox = $false
    $warn3.MinimizeBox = $false
    $wresult3 = $warn3.ShowDialog()
    }

function warn4 
{

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $warn4 = New-Object System.Windows.Forms.Form 
    $warn4.Text = "Error"
    $warn4.Size = New-Object System.Drawing.Size(400,200) 
    $warn4.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
    $warn4.Font = $font

    $wtext4 = New-Object System.Windows.Forms.Label
    $wtext4.Location = New-Object System.Drawing.Point(90,30) 
    $wtext4.Size = New-Object System.Drawing.Size(550,50) 
    $wtext4.Text = "User not found: $user"
    $warn4.Controls.Add($wtext4) 

    $wButton4 = New-Object System.Windows.Forms.Button
    $wButton4.Location = New-Object System.Drawing.Point(140,80)
    $wButton4.Size = New-Object System.Drawing.Size(100,50)
    $wButton4.Text = "OK"
    $wButton4.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $warn4.AcceptButton = $wButton4
    $warn4.Controls.Add($wButton4)

    $warn4.Topmost = $False
    $warn4.FormBorderStyle = 'Fixed3D'
    $warn4.MaximizeBox = $false
    $warn4.MinimizeBox = $false
    $wresult4 = $warn4.ShowDialog()
}

# Success message ###############################################################

function warn5 
{

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $warn5 = New-Object System.Windows.Forms.Form 
    $warn5.Text = "Error"
    $warn5.Size = New-Object System.Drawing.Size(400,200) 
    $warn5.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
    $warn5.Font = $font

    $wtext5 = New-Object System.Windows.Forms.Label
    $wtext5.Location = New-Object System.Drawing.Point(90,30) 
    $wtext5.Size = New-Object System.Drawing.Size(550,50) 
    $wtext5.Text = "User account unlocked"
    $warn5.Controls.Add($wtext5) 

    $wButton5 = New-Object System.Windows.Forms.Button
    $wButton5.Location = New-Object System.Drawing.Point(140,80)
    $wButton5.Size = New-Object System.Drawing.Size(100,50)
    $wButton5.Text = "OK"
    $wButton5.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $warn5.AcceptButton = $wButton5
    $warn5.Controls.Add($wButton5)

    $warn5.Topmost = $False
    $warn5.FormBorderStyle = 'Fixed3D'
    $warn5.MaximizeBox = $false
    $warn5.MinimizeBox = $false
    $wresult5 = $warn5.ShowDialog()
}

# Unlock AD account ################################################################
# Usage: uad $username
function uad
{
    param([string]$user)
    if(([string]::IsNullOrEmpty($user)) -or ($user -eq "help"))
    {
        #Write-Host "Enter username: "
        $user = $hostname.text
        if([string]::IsNullOrEmpty($user))
        {
            warn
            UAD # recall function if null
        }
    }

    try
    {
        if((Get-Aduser $user -Properties LockedOut).LockedOut -eq $true)
        {
            Unlock-ADAccount -Credential $mycred -Identity $user
            warn5
        }
        else
        {
            warn2           
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {    
        warn4
    }
    catch
    {
        warn3
        Write-Host "An error occured: "$error[0]
    }
}
# GUI ################################################################

function LAPSDIALOG {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form 
$form.Text = "AD Account Unlocker"
$form.Size = New-Object System.Drawing.Size(600,300)
$form.StartPosition = "CenterScreen"

$form.KeyPreview = $True
$form.Add_KeyDown({if ($_.KeyCode -eq "Enter") {uad}})
$form.Add_KeyDown({if ($_.KeyCode -eq "Escape") {$form.Close()}})

$font = New-Object System.Drawing.Font("Consolas",14,[System.Drawing.FontStyle]::Bold)
$form.Font = $font
$form.Topmost = $False

$Form.FormBorderStyle = 'Fixed3D'
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false

# Username ---------------------------------------------------------------------------

$hn = New-Object System.Windows.Forms.Label
$hn.Location = New-Object System.Drawing.Point(100,50) 
$hn.Size = New-Object System.Drawing.Size(120,25) 
$hn.Text = "Username -"
$form.Controls.Add($hn)

$hostname = New-Object System.Windows.Forms.TextBox 
$hostname.Location = New-Object System.Drawing.Point(250,50) 
$hostname.Size = New-Object System.Drawing.Size(280,10) 
$form.Controls.Add($hostname) 


# Unlock the Account ----------------------------------------------------------------

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(250,150)
$OKButton.Size = New-Object System.Drawing.Size(100,50)
$OKButton.Text = "Unlock"
$OKButton.Add_Click({uad})
$form.Controls.Add($OKButton)

$form.Topmost = $False
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){ exit }
}

Hide-PowerShell

LAPSDIALOG