$allnics = get-netadapterbinding | where-object componentID -eq 'ms_tcpip6'
Disable-NetAdapterBinding -Name $allnics.name -ComponentID ms_tcpip6