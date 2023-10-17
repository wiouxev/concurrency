# Define the file paths
$newScriptPath = "C:\temp\check_ODM_completion.ps1"
$shortcutPath = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\StartUp\check_ODM_completion.lnk"



# Prepare the PowerShell script content as a string
$scriptContent = @"
# Define the external batch file
$batchFilePath = "C:\temp\automate-odm.bat"

# Array to store match results
$matchResults = @()

# Update the function to return boolean based on match
function ReadRegistryValueAndCheckMatch($path, $valueName) {
    $result = $false
    if(Test-Path $path) {
        $value = Get-ItemProperty -Path $path -Name $valueName -ErrorAction SilentlyContinue
        if($null -ne $value) {
            $regValue = $value.$valueName
            if($regValue -match $variable) {
                Write-Host "Match found in ${path}\${valueName}: $regValue"
                $result = $true
            } else {
                Write-Host "No match found in ${path}\${valueName}. Value is: $regValue"
            }
        } else {
            Write-Host "${path}\${valueName} does not exist or could not be read."
        }
    } else {
        Write-Host "The registry path $path does not exist."
    }
    return $result
}

# Store the results
$matchResults += ReadRegistryValueAndCheckMatch $teamsRegKey $teamsRegValueName
$matchResults += ReadRegistryValueAndCheckMatch $outlookRegKey $outlookRegValueName
$matchResults += ReadRegistryValueAndCheckMatch $oneDriveRegKey $oneDriveRegValueName

# Check if there are three matches
if (($matchResults.Count -eq 3) -and ($matchResults -notcontains $false)) {
    # There are three matches, delete the batch file and script
    if (Test-Path $batchFilePath) {
        Remove-Item -Path $batchFilePath -Force
    }
    # Delete self
    Remove-Item -Path $PSCommandPath -Force
} else {
    # Less than three matches, execute the batch file
    if (Test-Path $batchFilePath) {
        Start-Process cmd.exe "/c $batchFilePath"
    } else {
        Write-Host "The batch file does not exist at the specified location."
    }
}

"@



# Write the new script
Set-Content -Path $newScriptPath -Value $scriptContent

# Create a shortcut to the new script
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$newScriptPath`""
$Shortcut.Save()
