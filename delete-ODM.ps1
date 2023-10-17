# The path to the file you want to delete
$fileToDelete = "C:\temp\automate-odm.bat"
$fileToDelete2 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\automate-odm-shortcut.lnk"

# Check if the file exists
if (Test-Path $fileToDelete) {
    # Try to delete the file
    try {
        Remove-Item -Path $fileToDelete -Force
        Write-Host "File deleted successfully."
    } catch {
        Write-Error "Failed to delete the file. $_"
    }
} else {
    Write-Warning "The file does not exist."
}

if (Test-Path $fileToDelete2) {
    # Try to delete the file
    try {
        Remove-Item -Path $fileToDelete2 -Force
        Write-Host "File deleted successfully."
    } catch {
        Write-Error "Failed to delete the file. $_"
    }
} else {
    Write-Warning "The file does not exist."
}
