$pid = $pid
$scriptPath = $PSCommandPath
$command = "`$process = Get-Process -Id $pid; `$process.WaitForExit(); Remove-Item -Path '$scriptPath'"

Start-Process -FilePath powershell.exe -ArgumentList "-Command $command" -WindowStyle Hidden
