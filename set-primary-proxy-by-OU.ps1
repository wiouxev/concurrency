Get-ADUser -Filter * -searchbase "OU=NPD,OU=GLOBAL,DC=infores,DC=com"-Properties mail,ProxyAddresses |
    Foreach {  
        $proxies = $_.ProxyAddresses | 
            ForEach-Object{
                $a = $_ -replace 'SMTP','smtp'
                if($a -match 'iriworldwide.com'){
                    $a -replace 'smtp','SMTP'
                }else{
                    $a
                }
            }
        $_.ProxyAddresses = $proxies
        Set-ADUser -instance $_
    }