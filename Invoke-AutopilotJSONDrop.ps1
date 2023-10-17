<# 

.SYNOPSIS 

    Prepares systems for tenant to tenant autopilot migration  

.NOTES 

    FileName:    Invoke-AutopilotJSONDrop.ps1 

    Author:      Maurice Daly 

    Contact:     @modaly_it 

    Created:     2019-05-29 

    Updated:     2019-05-29 

 

    Version history: 

1.0.0 - (2019-05-29) Script created 

#> 

 

function Write-LogEntry { 

param ( 

[parameter(Mandatory = $true, HelpMessage = "Value added to the log file.")] 

[ValidateNotNullOrEmpty()] 

[string]$Value, 

[parameter(Mandatory = $true, HelpMessage = "Severity for the log entry. 1 for Informational, 2 for Warning and 3 for Error.")] 

[ValidateNotNullOrEmpty()] 

[ValidateSet("1", "2", "3")] 

[string]$Severity, 

[parameter(Mandatory = $false, HelpMessage = "Name of the log file that the entry will written to.")] 

[ValidateNotNullOrEmpty()] 

[string]$FileName = "Invoke-AutopilotJSONDrop.log" 

) 

 

# Determine log file location 

$LogFilePath = Join-Path -Path (Join-Path -Path $env:windir -ChildPath "Temp") -ChildPath $FileName 

 

# Construct time stamp for log entry 

$Time = -join @((Get-Date -Format "HH:mm:ss.fff"), "+", (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias)) 

 

# Construct date for log entry 

$Date = (Get-Date -Format "MM-dd-yyyy") 

 

# Construct context for log entry 

$Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) 

 

# Construct final log entry 

$LogText = "<![LOG[$($Value)]LOG]!><time=""$($Time)"" date=""$($Date)"" component=""Invoke-AutopilotJSONDrop.log"" context=""$($Context)"" type=""$($Severity)"" thread=""$($PID)"" file="""">" 

 

# Add value to log file 

try { 

Out-File -InputObject $LogText -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop 

} catch [System.Exception] { 

Write-Warning -Message "Unable to append log entry to Invoke-AutopilotJSONDrop log file. Error message: $($_.Exception.Message)" 

} 

} 

 

# Autopilot JSON file name 

$AutopilotJSON = "AutopilotConfigurationFile.json" 

$JSONDropDirectory = (Join-Path -Path $env:windir -ChildPath "Provisioning\Autopilot") 

 

try { 

# Check for Autopilot file and run  

Write-LogEntry -Value "Checking for Autopilot provisioning folder" -Severity 1 

if ((Test-Path -Path (Join-Path -Path .\ -ChildPath $AutopilotJSON)) -eq $true) { 

Write-LogEntry -Value "Checking for AutopilotConfigurationFile.json file" -Severity 1 

if (-not (Test-Path -Path (Join-Path -Path $env:windir -ChildPath "Provisioning\Autopilot"))) { 

# Create Autopilot folder 

Write-LogEntry -Value "Creating Autopilot provisioning folder" -Severity 1 

New-Item -Path $JSONDropDirectory -Type Dir | Out-Null 

} 

Write-LogEntry -Value "Copying JSON file to the Autopilot provisioning folder" -Severity 1 

Copy-Item -Path $AutopilotJSON -Destination $JSONDropDirectory 

exit 0 

} 

} catch [System.Exception] { 

Write-Warning -Message "An error occured while deploying the Autopilot JSON: $($_.Exception.Message)"; exit 1 

} 

 