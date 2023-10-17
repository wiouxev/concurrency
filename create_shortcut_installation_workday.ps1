## Installation script ##

#Name of the shortcut
$shortcutName = "Workday"
 
$ScriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
 
Copy-Item -Path "$ScriptPath\$shortcutName.lnk" -Destination "$Env:Public\Desktop"
