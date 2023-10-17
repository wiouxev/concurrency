# Connect to Active Directory
Import-Module ActiveDirectory
$attribute="extensionattribute15"
$attributevalue="migrate"


# Select all user accounts in the specified OUs in csv and set the extensionattribute15 value to "migrate"
import-csv -path c:\temp\OU.csv | ForEach {
write-host "Updating Users in"$_.OU
Get-ADUser -Filter * -SearchBase $_.OU | Set-ADUser -Replace @{$attribute=$attributevalue} 
}


#future logging, put this at the end of the get-aduser line to export to desired logfile
#| select DistinguishedName, Name, objectclass, enabled, userprincipalname | export-csv -path $logfile