######################################################################################
#####################################################################################

## set wallpaper image
<# Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
#>

<#
$wallpaperPath = "C:\temp\circana-wallpaper.png"
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)

# Define the path and name of the registry key
$RegKeyPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$RegKeyName = "Wallpaper"

# Define the path of the wallpaper
$WallpaperPath = "C:\temp\circana-wallpaper.png"

# Check if the registry key exists, if not, create it
if (!(Test-Path $RegKeyPath)) {
    New-Item -Path $RegKeyPath -Force | Out-Null
}
# Set the registry key value
Set-ItemProperty -Path $RegKeyPath -Name $RegKeyName -Value $WallpaperPath -Type String
#>

#####################################################################################
#####################################################################################

##set lock screen image
$lockScreenPath = "C:\temp\circana-lockscreen.jpg"

if (-Not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
}

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -Value $lockScreenPath

#####################################################################################
######################################################################################

## disable "blur" effect for lock screen wallpaper at login screen
# Define the path and name of the registry key
$RegKeyPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
$RegKeyName = "DisableAcrylicBackgroundOnLogon"

# Check if the registry key exists, if not, create it
if (!(Test-Path $RegKeyPath)) {
    New-Item -Path $RegKeyPath -Force | Out-Null
}

# Set the registry key value
Set-ItemProperty -Path $RegKeyPath -Name $RegKeyName -Value 1 -Type DWord


#####################################################################################
#####################################################################################

##set "legal message" notice to migration message

<# Set the message title
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name legalnoticecaption -Value "Circana notice:"
#>

<# Set the message text
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name legalnoticetext -Value "If you are seeing this message, your migration to Circana was successful. Please review next step documentation and login with your @circana.com account."
#>


# Regex pattern for SIDs
$PatternSID = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'
 
# Get Username, SID, and location of ntuser.dat for all users
$ProfileList = gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' | Where-Object {$_.PSChildName -match $PatternSID} | 
    Select  @{name="SID";expression={$_.PSChildName}}, 
            @{name="UserHive";expression={"$($_.ProfileImagePath)\ntuser.dat"}}, 
            @{name="Username";expression={$_.ProfileImagePath -replace '^(.*[\\\/])', ''}}
 
# Get all user SIDs found in HKEY_USERS (ntuder.dat files that are loaded)
$LoadedHives = gci Registry::HKEY_USERS | ? {$_.PSChildname -match $PatternSID} | Select @{name="SID";expression={$_.PSChildName}}
 
# Get all users that are not currently logged
$UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select @{name="SID";expression={$_.InputObject}}, UserHive, Username

# Store the location for Windows system cached lock/login screen images
$cachedlockscreendir = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
$cachedlockscreendir2 = "$env:windir\System32\oobe\info\backgrounds"
 
# Loop through each profile on the machine
Foreach ($item in $ProfileList) {
    # Load User ntuser.dat if it's not already loaded
    IF ($item.SID -in $UnloadedHives.SID) {
        reg load HKU\$($Item.SID) $($Item.UserHive) | Out-Null
    }
 
    #####################################################################
    # This is where you can read/modify a users portion of the registry 
 
    # Path to the new image
    $imagePath = "C:\temp\circana-lockscreen.jpg"

    # Check if the registry key path exists, if not create it
    if(!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP")) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Force
    }

    # Check if the LockScreenImagePath property exists, if not create it
    if(!(Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImagePath" -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImagePath" -Value $imagePath -PropertyType String -Force
    }
    else {
        # If the property exists, just update its value
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImagePath" -Value $imagePath
    }

    # Check if the LockScreenImageStatus property exists, if not create it
    if(!(Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImageStatus" -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImageStatus" -Value 1 -PropertyType DWORD -Force
    }
    else {
        # If the property exists, just update its value
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImageStatus" -Value 1
    }

    # Path to the Spotlight settings in the user's hive
    $spotlightKeyPath = "HKU:\$($Item.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

    # Check if the registry key exists
    if (Test-Path -Path $spotlightKeyPath) {
        # Disable Windows Spotlight
        Set-ItemProperty -Path $spotlightKeyPath -Name "RotatingLockScreenEnabled" -Value 0
    }

    ## remove all files in windows cached locked screen folder(s)
    ## needs to be adjusted to properly claim each user file path?
    # Get-ChildItem -Path $cachedlockscreendir -Recurse | Remove-Item -Force -ErrorAction Ignore
    # Get-ChildItem -Path $cachedlockscreendir2 -Recurse | Remove-Item -Force -ErrorAction Ignore

    # Force the update to take effect immediately
    rundll32.exe user32.dll, UpdatePerUserSystemParameters


    <# This example lists the Uninstall keys for each user registry hive
    "{0}" -f $($item.Username) | Write-Output
    Get-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
        Foreach {"{0} {1}" -f "   Program:", $($_.DisplayName) | Write-Output}
    Get-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
        Foreach {"{0} {1}" -f "   Program:", $($_.DisplayName) | Write-Output}
    #>
    #####################################################################
 
    # Unload ntuser.dat        
    IF ($item.SID -in $UnloadedHives.SID) {
        ### Garbage collection and closing of ntuser.dat ###
        [gc]::Collect()
        reg unload HKU\$($Item.SID) | Out-Null
    }
}