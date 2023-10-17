# create a variable for the domain name
# $newDomain = "NewCo.com"
$newDomain = "circana.com"

# Connect to Active Directory (needed?)
Import-Module ActiveDirectory

# Get all AD users (do we need to filter it down to those with mail?)
$users = Get-ADUser -Filter *

# add proxy address to each user in the $users variable (can probably combine with below)
foreach ($user in $users) {
    $proxyAddress = "smtp:$($user.SamAccountName)@$newDomain"
    Set-ADUser -Identity $user -Add @{proxyAddresses=$proxyAddress}
}

# now set the new proxy address as primary SMTP for each user (can probably combine)
foreach ($user in $users) {
    Set-ADUser -Identity $user -EmailAddress "SMTP:$($user.SamAccountName)@$newDomain"
}

# now set the 'mail' attribute for each user to NewCo/circana (can probably combine)
foreach ($user in $users) {
    Set-ADUser -Identity $user -EmailAddress "$($user.SamAccountName)@$newDomain"
}