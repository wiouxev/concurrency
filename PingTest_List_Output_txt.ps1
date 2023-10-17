$Pingmaster = "C:\Temp\Workstations.txt"
$GoodPing = "C:\Temp\PingableServers.txt"
$BadPing = "C:\Temp\NonPingableServer.txt"

# Cleanup old Results file first.
remove-item $GoodPing
remove-item $BadPing

$servers = Get-Content $Pingmaster

foreach ($server in $servers)

{

    
    if (Test-Connection $server -Count 3 -ea 0 -Quiet)

    { 

    
   write $server   >> $GoodPing
    write-Host "$server is alive and Pinging  :) `n " -ForegroundColor Green

    } 

    else 

    { 

        write $server   >> $BadPing
        write-Host "$server is Not responding to Pings  :( `n " -ForegroundColor red

    }

    
}
 write-Host "***  I'm all Done pinging the servers!  :) *** `n " -ForegroundColor Yellow
