#Set-ExecutionPolicy remotesigned -force

# Script to change the wallpaper and lock screen for all users

# Define the paths to your images
$wallpaper = "C:\users\estueve\downloads\migrated.png"
$lockscreen = "C:\users\estueve\downloads\migrated2.png"

# Get the list of all user profile directories
$userProfileDirs = Get-ChildItem 'C:\Users' | Where-Object { $_.PSIsContainer }

foreach ($userProfileDir in $userProfileDirs) {
    # Load the user's NTUSER.DAT into the registry
    $ntuserPath = Join-Path $userProfileDir.FullName 'NTUSER.DAT'
    $hivePath = "HKU\TempHive"
    reg load $hivePath $ntuserPath

    # Set the wallpaper and lock screen
    $userWallpaperKeyPath = "$hivePath\Control Panel\Desktop"
    Set-ItemProperty -Path $userWallpaperKeyPath -Name Wallpaper -Value $wallpaperPath

    $userLockscreenKeyPath = "$hivePath\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
    Set-ItemProperty -Path $userLockscreenKeyPath -Name LockScreenImagePath -Value $lockScreenPath
    Set-ItemProperty -Path $userLockscreenKeyPath -Name LockScreenImageStatus -Value 1
    Set-ItemProperty -Path $userLockscreenKeyPath -Name LockScreenImageUrl -Value $lockScreenPath

    # Unload the user's NTUSER.DAT from the registry
    reg unload $hivePath
}

# Notify the system that the wallpaper has changed
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)
