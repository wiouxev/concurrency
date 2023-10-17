## Installation script ##

#Name of the shortcut
$shortcutName = "Intranet Shortcut"
 
$ScriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
 
Copy-Item -Path "$ScriptPath\$shortcutName.lnk" -Destination "$Env:Public\Desktop"
