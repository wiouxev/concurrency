#update this path for the log file or it will use the directory the script is executed in
$logfile = "log.txt"
#update the SearchBase to target the location of the OU you want to process
##commented to test csv
#$f = get-aduser -Filter * -SearchBase "OU=ConcurrencyTest,OU=Employees,OU=Users,OU=US,OU=AMER,DC=infores,DC=com"

##Add option to loop through Ous in a csv
##csv should have heading "OU" with OU in same format as above
##uncomment two lines below, one "{" at end and comment out $f above to use import csv

import-csv -path c:\temp\OU-IRI.csv | ForEach { 
#$f = get-aduser -Filter {mail -like '*'} -SearchBase $_.OU
##NEEDS REVIEW if limiting to iriworldwide, need to change to 
$f = get-aduser -Filter {mail -like '*iriworldwide.com*'} -SearchBase $_.OU

#loop through each item in the array
ForEach ($ff in $f) {
Write-host $ff
$thistime = get-date -Format MM-dd-yy-HH:ss
$thisuser = Get-ADuser $ff -Properties samaccountname, userprincipalname, targetAddress, mail, sn, givenName, proxyaddresses | select-object samaccountname,userprincipalname, targetAddress, mail, sn, givenName, @{n = "proxyAddress"; e = { $_.proxyAddresses | Where-object { $_ -clike "SMTP:*" } } } , mailNickname
#samaccountname is important as it is how get-aduser resolved users in the array
$thissam = $thisuser.samAccountName
$thisupn = $thisuser.UserPrincipalName
$thismail = $thisuser.mail
$thisproxy = $thisuser.proxyaddress
#create new nickname based on mailnickname field - this is recommended
#$thisnick = $thisuser.mailnickname
#$thischange = $thisnick + "@circana.com"
#createnickname based on first part of existing primary address - this is a common approach
$thisnick = $thismail.Split("@")[0] + "@circana.com"
$thismsg = "$thistime, User $thisupn, mail will be changed from $thismail to $thisnick, Primary Proxy SMTP will be changed from $thisproxy to SMTP:$thisnick, secondary proxy will be added for $thisnick and $thismail"

Write-host $thismsg
$thismsg | out-file $logfile -append

$test = "Not a test"
if ($test -eq "Not a test"){          
#update the addresses
##temporarily commented for testing
Set-ADUser -Identity $thissam -Remove @{Proxyaddresses=$thisproxy}
Set-ADUser -Identity $thissam -Add @{Proxyaddresses="SMTP:"+$thisnick}
Set-ADUser -Identity $thissam -Add @{Proxyaddresses="smtp:"+$thismail}
Set-ADUser -Identity $thissam -clear mail
Set-ADUser -Identity $thissam -Add @{mail="$thisnick"}

##reread AD and report updates
$updateuser = Get-ADuser $ff -Properties targetAddress, mail, sn, givenName, proxyaddresses | select-object targetAddress, mail, sn, givenName, @{n = "proxyAddress"; e = { $_.proxyAddresses | Where-object { $_ -clike "SMTP:*" } } } , mailNickname
$updatetime = get-date -Format MM-dd-yy-HH:ss
$updateproxy = $updateuser.proxyaddress
$updatemail = $updateuser.mail
$updatemsg = "$updatetime $thisupn now reads $updatemail | $updateproxy"
Write-host $updatemsg
$updatemsg | out-file $logfile -append
##end update
}
}

##uncomment for using csv import
}