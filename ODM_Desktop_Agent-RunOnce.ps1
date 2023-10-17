###################################via runonce registry key########################################

# Specify the application and command to run
#C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe
$applicationPath = "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
#$command = "-parameter1 value1 -parameter2 value2"

# Create the RunOnce key in the registry
    #HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
    #HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
    #HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
    #HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
$runOnceKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
New-Item -Path $runOnceKey -Force | Out-Null
#$runOnceKey2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
##New-Item -Path $runOnceKey2 -Force | Out-Null
#$runOnceKey3 = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"
##New-Item -Path $runOnceKey3 -Force | Out-Null
#$runOnceKey4 = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"
##New-Item -Path $runOnceKey4 -Force | Out-Null


# Set the command for the application in the RunOnce key
Set-ItemProperty -Path "$runOnceKey\" -Name "On Demand Migration Desktop Update Agent" -Value "$applicationPath "#$command"

# Display confirmation message
Write-Host "RunOnce command set for On Demand Migration Desktop Update Agent."


######################################via startup folder##############################################

# Specify the program to run
$programPath = "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpgradeAgent.exe"
#$arguments = "-parameter1 value1 -parameter2 value2"

# Get the current user's startup folder path
$startupFolderPath = [Environment]::GetFolderPath("Startup")

# Create a shortcut to the program in the user's startup folder
$shortcutPath = Join-Path -Path $startupFolderPath -ChildPath "ProgramShortcut.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $programPath
#$shortcut.Arguments = $arguments
$shortcut.Save()

# Display confirmation message
Write-Host "Shortcut created in the user's startup folder."
