## Uninstallation Script ##

#Name of the shortcut
$shortcutName = "Intranet Shortcut"
 
Remove-Item -Path "$Env:Public\Desktop\$shortcutName.lnk"