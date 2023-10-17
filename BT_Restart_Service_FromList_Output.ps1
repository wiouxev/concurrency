#List of servers that need specific service restarted
$servers = get-content "C:\Temp\List_Restart_Service.txt"

#Enter service to restart
$Service = "BTADMigratorAgentService"


foreach ($server in $servers) 
{ 
write-host "Restarting service $service on server $server" -ForegroundColor Yellow

Get-Service $Service -ComputerName $Server  | restart-Service -Force

}

write-host "Press enter to check status of all Servers $service service to make sure it's running" -ForegroundColor Red
pause


foreach($server in $servers) 
{ 
write-host "$server" -ForegroundColor yellow
Get-Service $Service -ComputerName $Server   |Format-Table -AutoSize
}