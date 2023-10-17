$IPType = "IPv4" 

$adapter = Get-NetAdapter | ? {$_.Status -eq "up"} 

#$interface = $adapter| ? {$_.Name -eq "Local Area Connection"} 

 

# Enable DHCP 

Foreach ($net in $adapter){ 

#$net | Set-NetIPInterface -DHCP Enabled 

# Configure the DNS Servers automatically 

$net | Set-DnsClientServerAddress -ResetServerAddresses 

} 