###############################################################################################
############# Pieces taken from Aaron's "Redirect-OneDriveFolders.ps1" script ###############
###############################################################################################

 

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
