
#requires -version 5.1 
#requires -modules MSOnline

Function Set-MSOLUserImmutableIDFromADuser{
param
(
    
    
    
    [ValidateNotNullOrEmpty()]
    [string]$samAccountName,

    [Parameter()]
    [switch]$cloudUPN

) 
Import-Module MSOnline
Connect-MsolService

try{

   $ADUser = get-aduser -identity $samAccountName  -Properties ObjectGUID

}catch{

    write-error "$_" -ErrorAction Stop
}

if($aduser.samAccountName.count -eq 1){

$ImmutableID =  [system.convert]::ToBase64String(([GUID]($AdUser.ObjectGUID)).tobytearray())

try{
    Set-MsolUser -UserPrincipalName $cloudUPN -ImmutableId $ImmutableID
    
    }catch{
    
        write-error "Error setting immutable id" -ErrorAction Stop 
    }
}else{

    write-error "Error getting AD user" -ErrorAction Stop 
}

}