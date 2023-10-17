$computerName = 'COMPUTER_NAME'  # Replace with the actual computer name
$maxAttempts = 30  # Maximum number of attempts to check if the computer is reachable
$retryDelay = 10  # Delay in seconds between each attempt

# Wait for the computer to finish rebooting
for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    Write-Host "Attempt $attempt: Checking if $computerName is reachable..."
    
    # Ping the computer or check if it responds to a specific command
    $pingResult = Test-Connection -ComputerName $computerName -Quiet -Count 1
    
    if ($pingResult) {
        Write-Host "Computer $computerName is reachable. Proceeding with the command."
        break  # Exit the loop and continue with your desired command
    }
    else {
        Write-Host "Computer $computerName is not reachable. Waiting $retryDelay seconds..."
        Start-Sleep -Seconds $retryDelay
    }
}

# Your desired command goes here
# For example, you can execute another PowerShell command or script:
Write-Host "Executing your desired command on $computerName"


###############################################################################################

#Pending reboot key location:
#HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending

$registryPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing'
$keyName = 'RebootPending'

# Check if the registry key exists
if (Test-Path -Path "$registryPath\$keyName") {
    Write-Host "The registry key $registryPath\$keyName exists."
}
else {
    Write-Host "The registry key $registryPath\$keyName does not exist."
}


##############################################################################################

if(check-if-computer-needs-a-reboot){
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Runonce" /V "Postboot" /d "\"%~dpPostboot.ps1\" MyParameters" /t REG_SZ /f
Write-Host "The machine is rebooting..."
Restart-Computer -Wait -Force
}
# Fall through if reboot was not needed, so continue with part 2
Write-Host "No pending reboot... continuing"
"%~dpPostboot.ps1"

##############################################################################################
