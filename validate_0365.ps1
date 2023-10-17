# Wait to start to allow original ODM autolaunch to do its thing
#Start-Sleep -Seconds 120
<# start section to disable quickedit mode (should fix the 'user clicks inside PS window' issue)
function Disable-QuickEditMode {
    $ConsoleHandle = [Microsoft.Win32.NativeMethods]::GetStdHandle(-10)
    $ConsoleMode = New-Object UInt32
    [Microsoft.Win32.NativeMethods]::GetConsoleMode($ConsoleHandle, [ref]$ConsoleMode) | Out-Null
    $ConsoleMode = $ConsoleMode -band (-bnot 0x0040) # Clear the ENABLE_QUICK_EDIT_MODE flag
    [Microsoft.Win32.NativeMethods]::SetConsoleMode($ConsoleHandle, $ConsoleMode) | Out-Null
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class NativeMethods {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
}
"@

Disable-QuickEditMode
#>

#set-executionpolicy remotesigned -scope process

# Define the external batch file
$batchFilePath = "C:\temp\automate-odm.bat"
$batchFileShortcut = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\StartUp\check_ODM_completion.lnk"
$PSCommandShortcut = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\StartUp\automate-odm-shortcut.lnk"

# Array to store match results
$matchResults = @()

# Define the registry keys
$teamsRegKey = "HKCU:\SOFTWARE\Microsoft\Office\Teams"
$teamsRegValueName = "homeuserUPN"

$outlookRegKey = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook"
$outlookRegValueName = "DefaultProfile" #$outlookRegValueName = "Profiles" #$outlookRegValueName = "npd.concurrency03@circana.com"

#$outlookRegKey = "HKCU:\SOFTWARE\Microsoft\Office\Outlook\Settings"
#$outlookRegValueName = "Accounts"

$oneDriveRegKey = "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1" #$oneDriveRegKey = "HKCU:\SOFTWARE\Microsoft\OneDrive"
$oneDriveRegValueName = "UserEmail" #$oneDriveRegValueName = "UserDomainCollection"

#$variable = "concurrency"  ## test. run when you dont want to self destruct
$variable = "circana" ## not a test. run when ready to self destruct


# Update the function to return boolean based on match
function ReadRegistryValueAndCheckMatch($path, $valueName) {
    $result = $false
    if(Test-Path $path) {
        $value = Get-ItemProperty -Path $path -Name $valueName -ErrorAction SilentlyContinue
        if($null -ne $value) {
            $regValue = $value.$valueName
            if($regValue -match $variable) {
                #Write-Host "`nMatch found in ${path}\${valueName}: $regValue `n"
                $result = $true
            } else {
                #Write-Host "`nNo match found in ${path}\${valueName}. Value is: $regValue. `n`nPlease complete the On Demand Migration Desktop Update Agent`n"
            }
        } else {
            #Write-Host "${path}\${valueName} does not exist or could not be read."
        }
    } else {
        #Write-Host "The registry path $path does not exist."
    }
    return $result
}

# Store the results
$matchResults += ReadRegistryValueAndCheckMatch $teamsRegKey $teamsRegValueName
$matchResults += ReadRegistryValueAndCheckMatch $oneDriveRegKey $oneDriveRegValueName
$matchResults += ReadRegistryValueAndCheckMatch $outlookRegKey $outlookRegValueName

# Check if there are three matches
if (($matchResults.Count -eq 3) -and ($matchResults -notcontains $false)) {
    # There are three matches, delete the batch file and script
    if (Test-Path $batchFilePath) {
        Remove-Item -Path $batchFilePath -Force
        #Remove-Item -Path $batchFileShortcut -Force (Need admin rights)
    }
    # Delete self
    #Remove-Item -Path $PSCommandPath -Force
        #Alternative self-deletion
        #$command = $PSCommandPath -replace '\\', '\\\\'
        #Start-Process -NoNewWindow -FilePath "PowerShell.exe" -ArgumentList "-Command ""$file = '$command'; Start-Sleep -Seconds 2; Remove-Item -Path `$file"""
        #Second Alternative self-deletion
            $scriptToDelete = $PSCommandPath
            Start-Job -ScriptBlock {
            param($Path)
            Start-Sleep -Seconds 2
            Remove-Item -Path $Path -Force
        } -ArgumentList $scriptToDelete
#Remove-Item -Path $PSCommandShortcut -Force (Need admin rights)
    #re-run PS script (loops this script to run until success)
    # & $PSCommandPath
} else {
    # Less than three matches, execute the batch file and re-run PS script
    if (Test-Path $batchFilePath) {
        Start-Process -WindowStyle Hidden -FilePath cmd.exe -ArgumentList "/c $batchFilePath"
            #Start-Process cmd.exe "/c $batchFilePath" (old method, shows window, use for troubleshooting)
        #re-run PS script after some delay (loops this script to run on timer until success)
        #write-host "Checking again in 4 minutes..."
        start-sleep -Seconds 30
        & $PSCommandPath
    } else {
        #Write-Host "The batch file does not exist at the specified location."
    }
}

