$sourceFolder = "C:\temp\"
$destinationFolder = "C:\Program Files (x86)\Binary Tree\ADPro Agent\Files"
$partialFileName = "mapped_drives"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\get-mapped-drives.lnk"  # Adjust the file name and path accordingly

# Check if the source folder exists
if (Test-Path $sourceFolder -PathType Container) {
    # Check if the destination folder exists
    if (Test-Path $destinationFolder -PathType Container) {
        # Get all files in the source folder that partially match the specified filename
        $matchingFiles = Get-ChildItem -Path $sourceFolder -Filter "*$partialFileName*" -File

        if ($matchingFiles.Count -gt 0) {
            foreach ($file in $matchingFiles) {
                # Build the destination file path
                $destinationFile = Join-Path $destinationFolder $file.Name

                # Copy the file
                Copy-Item -Path $file.FullName -Destination $destinationFile -Force
            }

            # After moving "MACHINENAME_mapped_drives.csv" check for script shortcut and delete
            if (Test-Path $ShortcutPath) {
                Remove-Item -Path $ShortcutPath -Force
                Write-Host "Mapped drives shortcut deleted successfully."
            }

            Write-Host "Files copied successfully."
        } else {
            Write-Host "No matching files found."
        }
    } else {
        Write-Host "Destination folder not found."
    }
} else {
    Write-Host "Source folder not found."
}
