param(
# Teams open in the background Hidden $true or $false
[boolean]$OpenAsHidden=$True,
# Teams open automatically at user login $true or $false
[boolean]$OpenAtLogin=$False,
# Close Teams App fully instead of running on Taskbar $true or $false
[boolean]$RunningOnClose=$True
)

# stop teams
Get-Process -Name Teams -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

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
    #"{0}" -f $($item.Username) | Write-Output
    #Get-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    #    Foreach {"{0} {1}" -f "   Program:", $($_.DisplayName) | Write-Output}
    #Get-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    #    Foreach {"{0} {1}" -f "   Program:", $($_.DisplayName) | Write-Output}
    # Remove Registry Key Prop
    Remove-ItemProperty registry::HKEY_USERS\$($Item.SID)\Software\Microsoft\Windows\CurrentVersion\Run -Name "com.squirrel.Teams.Teams" -ErrorAction SilentlyContinue    
    #####################################################################
 
    # Unload ntuser.dat        
    IF ($item.SID -in $UnloadedHives.SID) {
        ### Garbage collection and closing of ntuser.dat ###
        [gc]::Collect()
        reg unload HKU\$($Item.SID) | Out-Null
    }
}

# attempt to update each user teams config json file
$users = Get-ChildItem (Join-Path -Path $env:SystemDrive -ChildPath 'Users') -Exclude 'Public', 'defaultuser0', 'sgriffin', 'test', 'ADMINI~*'
if ($null -ne $users) {
    foreach ($user in $users) {
        $TeamsJson = Join-Path -Path $user.FullName -ChildPath "AppData\Roaming\Microsoft\Teams\desktop-config.json"
        if(Test-Path -path $TeamsJson -PathType Leaf){
            Write-Output "Updating $TeamsJson"
            $FileContent=Get-Content -Path "$TeamsJson"
            # Convert file content from JSON format to PowerShell object
            $JSONObject=ConvertFrom-Json -InputObject "$FileContent"
            # Update Object settings
            $JSONObject.appPreferenceSettings.OpenAsHidden=$OpenAsHidden
            $JSONObject.appPreferenceSettings.OpenAtLogin=$OpenAtLogin
            $JSONObject.appPreferenceSettings.RunningOnClose=$RunningOnClose
            # Convert Object back to JSON format
            $NewFileContent=$JSONObject | ConvertTo-Json
            # Update configuration in file
            $NewFileContent | Set-Content -Path "$TeamsJson"
        }
    }            
}

start-sleep -Seconds 10
<#
$consoleuser = ((Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty username) -split '\\')[1]
$LoggedOnUser = Join-Path -Path $env:SystemDrive -ChildPath "Users\$consoleuser"

If((Test-Path -Path "$LoggedOnUser\Appdata\local\Microsoft\Teams\Update.exe" -PathType Leaf) -eq $True){
    #Start-Process -FilePath "$InstallFolder\DesktopInfo.exe" -PassThru
    $action = New-ScheduledTaskAction -Execute "$LoggedOnUser\Appdata\local\Microsoft\Teams\Update.exe" -Argument "--processStart ""Teams.exe"""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance –ClassName Win32_ComputerSystem | Select-Object -expand UserName)
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
    Register-ScheduledTask teams -InputObject $task
    Start-ScheduledTask -TaskName teams
    Start-Sleep -Seconds 5
    Unregister-ScheduledTask -TaskName teams -Confirm:$false
    Write-Output "starting: $LoggedOnUser\Appdata\local\Microsoft\Teams\Update.exe --processStart ""Teams.exe"""
}
#>