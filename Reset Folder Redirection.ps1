
# Regex pattern for SIDs
$PatternSID = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'
 
# Get Username, SID, and location of ntuser.dat for all users
$ProfileList = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' | Where-Object {$_.PSChildName -match $PatternSID} | 
    Select-Object  @{name="SID";expression={$_.PSChildName}}, 
            @{name="UserHive";expression={"$($_.ProfileImagePath)\ntuser.dat"}}, 
            @{name="Username";expression={$_.ProfileImagePath -replace '^(.*[\\\/])', ''}}
 
# Get all user SIDs found in HKEY_USERS (ntuder.dat files that are loaded)
$LoadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object {$_.PSChildname -match $PatternSID} | Select-Object @{name="SID";expression={$_.PSChildName}}
 
# Get all users that are not currently logged
$UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select-Object @{name="SID";expression={$_.InputObject}}, UserHive, Username

# Loop through each profile on the machine
Foreach ($item in $ProfileList) {
    # Load User ntuser.dat if it's not already loaded

        reg load HKU\$($Item.SID) $($Item.UserHive) | Out-Null

 
    #####################################################################
    # This is where you can read/modify a users portion of the registry 
 
    # This example lists the Uninstall keys for each user registry hive
    "{0}" -f $($item.Username) | Write-Output


##Set folder redirection to default
$RegistryPath = "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
set-ItemProperty -Path $RegistryPath -Name Desktop -Value "%USERPROFILE%\Desktop" -Force
set-ItemProperty -Path $RegistryPath -Name Personal -Value "%USERPROFILE%\Documents" -Force
set-ItemProperty -Path $RegistryPath -Name 'My Pictures' -Value "%USERPROFILE%\pictures" -Force
set-ItemProperty -Path $RegistryPath -Name '{0DDD015D-B06C-45D5-8C4C-F59713854639}' -Value "%USERPROFILE%\pictures" -Force
set-ItemProperty -Path $RegistryPath -Name '{F42EE2D3-909F-4907-8871-4C22FC0BF756}' -Value "%USERPROFILE%\Documents" -Force
    


    #####################################################################
 
    # Unload ntuser.dat        

        ### Garbage collection and closing of ntuser.dat ###
        [gc]::Collect()
        reg unload HKU\$($Item.SID) | Out-Null

}