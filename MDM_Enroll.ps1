#To manually force the device enrollment, use this as a "Re-enroll command"


deviceenroller.exe /c /autoenrollmdm


#Also be sure to setup your MDM enrollment GPO to use Device Credential (so you don't need a user to be logged in)
##Enroll a Windows device automatically using Group Policy - Windows Client Management | Microsoft Learn
#IF you don't see "Device Credential", you will need to update your base ADMX templates (and since they are on Windows Server 2008 R2 for their forest level this may be necessary)