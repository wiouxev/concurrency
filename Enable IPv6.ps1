$allnics2 = get-netadapterbinding | where-object componentID -eq 'ms_tcpip6' 
Enable-NetAdapterBinding -Name $allnics2.name -ComponentID ms_tcpip6