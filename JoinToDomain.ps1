$domain = "corp.alliance.lan"

$password = "install" | ConvertTo-SecureString -asPlainText -Force

$username = "$domain\spii"

$credential = New-Object System.Management.Automation.PSCredential($username,$password)

Add-Computer -DomainName $domain -Credential $credential
