$Service = "BTADMigratorAgentService"
#$Server = "MXENS-W-RPM619"

$servers = get-content "C:\Temp\Servers_Service_List.txt"

foreach ($server in $servers) 
{ 
Get-Service $Service -ComputerName $Server | Select-Object MachineName,Name,Status,StartType   |  export-csv "c:\temp\Servers_Service_Status.csv" -NoTypeInformation -append # |Format-Table -AutoSize

}