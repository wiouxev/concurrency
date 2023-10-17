# Get currently logged in user
$username = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName).Split('\')[1]

# script content
$scriptContent = @'
Add-Type -AssemblyName System.Windows.Forms
$message = "Your migration process is starting in 15 minutes. Your computer will reboot several times during the process."
[Windows.Forms.MessageBox]::Show($message, "Warning", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning)
Start-Sleep -Seconds 900
'@


# Specify script file path
$scriptPath = "C:\temp\user_migration_warning.ps1"


# Check if the script file exists. If not, create it
if (-Not (Test-Path -Path $scriptPath)) {
    New-Item -Path $scriptPath -ItemType File -Force
    Set-Content -Path $scriptPath -Value $scriptContent
}

# Task name
$taskName = "user_migration_warning"


# Check if the task exists. If not, create it
if (-Not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $scriptPath"
        #-Argument "-WindowStyle Hidden -File $scriptPath"
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    Register-ScheduledTask -TaskName $taskName -Action $Action -Principal $Principal
}


# Start the task
Start-ScheduledTask -TaskName $taskName