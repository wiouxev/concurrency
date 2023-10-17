# Define the external batch file
$batchFilePath = "C:\temp\automate-odm.bat"

# Array to store match results
$matchResults = @()

# Define the registry keys
$teamsRegKey = "HKCU:\SOFTWARE\Microsoft\Office\Teams"
$teamsRegValueName = "homeuserUPN"

# $outlookRegKey = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles"
# $outlookRegValueName = "npd.concurrency03@circana.com"
$outlookRegKey = "HKCU:\SOFTWARE\Microsoft\Office\Outlook\Settings"
$outlookRegValueName = "Accounts"

$oneDriveRegKey = "HKCU:\SOFTWARE\Microsoft\OneDrive"
$oneDriveRegValueName = "UserDomainCollection"

$variable = "circana"

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
$matchResults += ReadRegistryValueAndCheckMatch $oneDriveRegKey $oneDriveRegValueName
$matchResults += ReadRegistryValueAndCheckMatch $outlookRegKey $outlookRegValueName



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





# create a shortcut in "shell: common startup" to this powershell script
## that will ensure it will auto-run on logon, check for registry key matches
## add command to run the original automate-odm tool bat file if registry keys don't match
# add command to self destruct PS script/shortcut and delete the batch file if all 3 reg keys match


######### Alternative Outlook process #############
# $outlookApplication = New-Object -ComObject 'Outlook.Application'
# $accounts = $outlookApplication.Session.Accounts
# $accounts | Select DisplayName, SmtpAddress
# $accounts | FL
# $outlookApplication.Application.DefaultProfileName