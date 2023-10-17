$A = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
$T = New-ScheduledTaskTrigger -AtLogOn
$S = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 0)
$U = [systemstring]"$env:USERDOMAIN\$env:USERNAME"
Register-ScheduledTask -TaskName "Automate ODM Desktop Agent" -Trigger $T -Action $A -User $U

#########################################################################################################

#Just change the command and give it a name that’s not test
#It will run once as the first user to login and then will delete itself

$A = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
$T = New-ScheduledTaskTrigger -AtLogOn
$S = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 0)
$U = New-Object -TypeName System.Security.Principal.NTAccount -ArgumentList IRI_CORP, nconcu06 #$env:USERDOMAIN, $env:USERNAME
Register-ScheduledTask -TaskName "Automated ODM Desktop Agent3" -Trigger $T -Action $A -User $U
##this one worked, but had to specify the user account


##########################################################################################################

    
$A = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
$T = New-ScheduledTaskTrigger -AtLogOn
$S = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 0)
$users = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true }
foreach ($user in $users) {
    $U = New-Object -TypeName System.Security.Principal.NTAccount -ArgumentList $user.Domain, $user.Name
    Register-ScheduledTask -TaskName "Automated ODM Desktop Agent" -Trigger $T -Action $A -User $U
}

$T = New-ScheduledTaskTrigger -AtLogOn
$A = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
$S = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 0)

$users = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true }
foreach ($user in $users) {
    $taskName = "AutomatedODMDesktopAgent3_$($user.Name)"
    $U = New-Object -TypeName System.Security.Principal.NTAccount -ArgumentList $user.Domain, $user.Name
    Register-ScheduledTask -TaskName $taskName -Trigger $T -Action $A -User $U -ErrorAction SilentlyContinue
}
