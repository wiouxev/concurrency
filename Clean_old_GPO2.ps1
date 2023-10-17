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
    IF ($item.SID -in $UnloadedHives.SID) {
        reg load HKU\$($Item.SID) $($Item.UserHive) | Out-Null
    }
 
    #####################################################################
    # This is where you can read/modify a users portion of the registry 
 
    # This example lists the Uninstall keys for each user registry hive
    "{0}" -f $($item.Username) | Write-Output

    #Remove-Item "$env:windir\system32\GroupPolicy" -Force -Recurse
    Remove-Item -Path “HKLM:\Software\Policies\Microsoft” -Force -Recurse
    Remove-Item -Path “HKCU:\Software\Policies\Microsoft” -Force -Recurse
    Remove-Item -Path “HKCU:\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects” -Force -Recurse
    Remove-Item -Path “HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies” -Force -Recurse

    #Remove-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Microsoft\Windows\CurrentVersion\Run -Name "Onedrive" -ErrorAction SilentlyContinue
    #get-childitem -Path "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\OneDrive\Accounts" | remove-item -recurse -force -Verbose -ErrorAction SilentlyContinue
    #get-childitem -Path "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace" | Where-Object{$_.name -like "*04271989*"} | remove-item -Recurse -force -Verbose -ErrorAction SilentlyContinue
#removed due to personal onedrive namespace
#    get-childitem -Path "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace" | Where-Object{$_.name -like "*018D5C66*"} | remove-item -Recurse -force -Verbose -ErrorAction SilentlyContinue
    
#Enable ADAL
#Set variables to indicate value and key to set
#$RegistryPath = "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\OneDrive"

#Reset the login state
#set-ItemProperty -Path $RegistryPath -Name EnableADAL -Value 1 -Force
#set-ItemProperty -Path $RegistryPath -Name SilentBusinessConfigCompleted -Value 0 -Force
#set-ItemProperty -Path $RegistryPath -Name DefaultToBusinessFRE -Value 0 -Force
#set-ItemProperty -Path $RegistryPath -Name ClientEverSignedIn -Value 0 -Force
#set-ItemProperty -Path $RegistryPath -Name ClientNotSignedInBalloonState -Value 0 -Force
#Set-itemproperty -Path $RegistryPath -Name DisablePersonalSync -Value 0

#Reset Login for background launch on user login
#New-ItemProperty -Path "registry::HKEY_USERS\$($Item.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name OneDrive -Value '"C:\Program Files\Microsoft OneDrive\OneDrive.exe" /background' -PropertyType String -Force


    #####################################################################
 
    # Unload ntuser.dat        
    IF ($item.SID -in $UnloadedHives.SID) {
        ### Garbage collection and closing of ntuser.dat ###
        [gc]::Collect()
        reg unload HKU\$($Item.SID) | Out-Null
    }
}