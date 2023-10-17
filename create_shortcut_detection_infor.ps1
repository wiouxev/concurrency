## Detection Script ##

#Name of the shortcut
$shortcutName = "Infor" 
 
if (Test-Path -Path "$Env:Public\Desktop\$shortcutName.lnk"){
    Write-Output "0"
}