$batchContent = @'
:loop
#time is miliseconds (1000 = 1 second)
ping odmduaproduspublicapi.azurewebsites.net -n 1 -w 180000
if errorlevel 1 goto loop

# Wait for an additional 1 minute (60 seconds)
timeout /t 180 /nobreak

# Start the application
START "" "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"

# Invoke PowerShell script to check the registry keys
for /f "delims=" %%i in ('powershell -Command "(Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Office\Teams' -Name 'homeuserUPN' -ErrorAction SilentlyContinue).'homeuserUPN' -match 'concurrency' -and (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Office\Outlook\Settings' -Name 'Accounts' -ErrorAction SilentlyContinue).'Accounts' -match 'concurrency' -and (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\OneDrive' -Name 'UserDomainCollection' -ErrorAction SilentlyContinue).'UserDomainCollection' -match 'concurrency'"') do set "match=%%i"
if "%match%"=="True" (
    (goto) 2>nul & del "%~f0"
) else (
    goto loop
)
'@

$batchFilePath = "C:\temp\automate-odm.bat"
$batchContent | Out-File -FilePath $batchFilePath -Encoding ASCII
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\automate-odm-shortcut.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $batchFilePath
$shortcut.WindowStyle = 7  # Minimized window
$shortcut.Save()
