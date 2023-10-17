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