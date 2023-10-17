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

# Function to read registry values and check if they match with $variable
function ReadRegistryValueAndCheckMatch($path, $valueName) {
    if(Test-Path $path) {
        $value = Get-ItemProperty -Path $path -Name $valueName -ErrorAction SilentlyContinue
        if($null -ne $value) {
            $regValue = $value.$valueName
            if($regValue -match $variable) {
                Write-Host "Match found in ${path}\${valueName}: $regValue"
            } else {
                Write-Host "No match found in ${path}\${valueName}. Value is: $regValue"
            }
        } else {
            Write-Host "${path}\${valueName} does not exist or could not be read."
        }
    } else {
        Write-Host "The registry path $path does not exist."
    }
}

# Get the values and check for match
ReadRegistryValueAndCheckMatch $teamsRegKey $teamsRegValueName
ReadRegistryValueAndCheckMatch $outlookRegKey $outlookRegValueName
ReadRegistryValueAndCheckMatch $oneDriveRegKey $oneDriveRegValueName

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