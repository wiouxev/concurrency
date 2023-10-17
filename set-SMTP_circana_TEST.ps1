# new domain is circana.com

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



    # adds a proxyaddress for the new domain... for each user? (cirwhatever.com)
#Get-ADUser -Filter * -searchbase "OU=NPD,OU=GLOBAL,DC=infores,DC=com"-Properties UserPrincipalName 
   #Foreach {
   # $users = $_.UserPrincipalName
   #     ForEach-Object{
   #         Set-Mailbox "$_.UserPrincipalName" -EmailAddresses @{add="$_.UserPrincipalName@circana.com"}

# setup
Import-Module ActiveDirectory
$domain = "circana.com"


# Get all user objects from AD
$users = Get-ADUser -Filter * -searchbase "OU=NPD,OU=GLOBAL,DC=infores,DC=com"
    # $users = Get-ADUser -Filter *

# Loop through each user and add the proxy address (as primary?) to their email addresses collection
    Foreach {
    $user = $_.UserPrincipalName |
        ForEach-Object{
            $emailAddresses = $user.EmailAddress
            $proxyAddress = $_.UserPrincipalName.@circana.com |

    # Check if the proxy address exists
    if ($emailAddresses -notcontains "SMTP:$proxyAddress") {
        $emailAddresses += "SMTP:$proxyAddress"

        # Update the user object in Active Directory with the new email addresses collection
        Set-ADUser -Identity $user.DistinguishedName -EmailAddress $emailAddresses

        # Update the mail attribute
        Set-ADUser -Identity $user -EmailAddress $proxyAddress
    }
}


# add a step for verification? 