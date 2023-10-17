<#
.SYNOPSIS
This script finalizes a user's migration by moving user data in Desktop, Documents, and Pictures directories and rebooting the system.

.DESCRIPTION
The script will first display a message box to the user, notifying them of the imminent migration finalization. 
Then, it checks the user's Desktop, Documents, and Pictures directories and moves any data to the default directories if they are not already there. 
It also modifies the registry to point these folders to their default locations. 
After completing these steps, a notification is displayed to inform the user of a system reboot in 30 seconds. 
Finally, the system is forcibly restarted.

.PARAMETER None
This script does not take any parameters.

.EXAMPLE
PS C:\> .\MigrationScript.ps1
This example runs the script from the PowerShell prompt. Ensure that you have administrative rights before running this script.

.NOTES
Please run this script with Administrative privileges to ensure that it can make changes to the registry and move user data.
This script assumes that the default location for Desktop, Documents, and Pictures directories are in the format "C:\Users\$env:USERNAME\{Directory}".
This script is designed for Windows systems and should be run in a PowerShell environment.
#>


# Set the message to be displayed in the pop-up window

$message = "Press OK to begin finishing your migration"

 

# Display the pop-up window with the message and an "OK" button

[System.Windows.Forms.MessageBox]::Show($message, "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

 

# Get the current user's desktop path

$desktopPath = [Environment]::GetFolderPath('Desktop')

 

if ($desktopPath -ne "C:\Users\$env:USERNAME\Desktop") {

 

    # Set the registry key to the default desktop location

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value "C:\Users\$env:USERNAME\Desktop"

 

    # Move the files from the current desktop path to the new default desktop path

    Move-Item -Path "$desktopPath\*" -Destination "C:\Users\$env:USERNAME\Desktop"

 

}

 

# Get the current user's Documents path

$documentsPath = [Environment]::GetFolderPath('MyDocuments')

 

if ($documentsPath -ne "C:\Users\$env:USERNAME\Documents") {

 

    # Set the registry key to the default Documents location

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal" -Value "C:\Users\$env:USERNAME\Documents"

 

    # Move the files from the current Documents path to the new default Documents path

    Move-Item -Path "$documentsPath\*" -Destination "C:\Users\$env:USERNAME\Documents"

 

}

 

# Get the current user's pictures path

$picturesPath = [Environment]::GetFolderPath('MyPictures')

 

if ($picturesPath -ne "C:\Users\$env:USERNAME\Pictures") {

 

    # Set the registry key to the default pictures location

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures" -Value "C:\Users\$env:USERNAME\Pictures"

 

    # Move the files from the current pictures path to the new default pictures path

    Move-Item -Path "$picturesPath\*" -Destination "C:\Users\$env:USERNAME\Pictures"

 

}

 

# Set the message to be displayed in the pop-up window

$message = "Your computer will reboot in 30 seconds."

 

# Set the duration of time to display the pop-up window in seconds

$duration = 30

 

# Display the pop-up window with the message and an "OK" button

$popup = New-Object -ComObject WScript.Shell

$popup.Popup($message, 0, "Reboot notification", 0x40)




Restart-Computer -Force -Wait $duration