#This will leverage Wscript Popup and display an OK window that will disappear after X number of seconds.  
# You will still need to execute Powershell script silently. You may have to change execution policy ( powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "<script_name>")

 

Function MSG_AutoClose
{
$sh = New-Object -ComObject "Wscript.Shell"
$intButton = $sh.Popup("Test ",30,"Title Here (Script will continue in 30 seconds)",0+64)
}