# Define the search criteria
$searchValue = "migrate"
$searchAttribute = "extensionAttribute15"
$searchDomain = "npd.com"

# Search for users with the specified attribute value
#$users = Get-ADUser -Filter "{$searchAttribute -ne ''}" -Properties $searchAttribute -Server $searchDomain

# 
$users = get-aduser -filter {extensionattribute15 -eq "migrate"} -Properties extensionAttribute15 -Server $searchDomain

# Export the list of users to a CSV file
$users | Select-Object SamAccountName, Name, Email, UserPrincipalName, $searchAttribute | Export-Csv -Path "C:\concurrency\ext15_users_npd.csv" -NoTypeInformation


