#The goal of this script is to do a quicker export of Intune devices with varying parameters
#Then build on the script to eventually output a word doc or draft email for BP communication
#and simplify current process

#connect to tenant
Connect-MSGraph -AdminConsent
Connect-AzureAD

#This should be the 'core' call to Intune to make sure its looking at ALL devices when we are searching within parameters
#get-IntuneManagedDevice | get-msgraphallpages

#This gets a count of all Managed devices in Intune .. this establishes a baseline
#$AllDevicesCount = get-IntuneManagedDevice | get-msgraphallpages | Measure-Object | select Count
#Write-Host "Managed devices on Intune: '$AllDevicesCount'"

#to start filtering down the search/output for our purposes, let's simplify by storing all Intune devices into a variable for quicker pulling
#$AllDevices = get-IntuneManagedDevice | Get-msgraphallpages 

#now we can call $alldevices instead of doing a new pull via MSgraph. 
#$alldevices.count to test if it worked

#list of parameters to filter by:
#id                                        : 52741163-1067-4fa2-8331-4dc5de5b43f1
#userId                                    : 59439425-a00d-43d0-8c15-490b47f73091
#deviceName                                : Amy’s iPad
#managedDeviceOwnerType                    : company
#enrolledDateTime                          : 11/26/2019 10:05:50 PM
#lastSyncDateTime                          : 6/19/2020 2:46:54 PM
#operatingSystem                           : iOS
#complianceState                           : compliant
#jailBroken                                : False
#managementAgent                           : mdm
#osVersion                                 : 13.5.1
#easActivated                              : True
#easDeviceId                               : AMVSRTFKOD119BPHRBS98FBJD8
#easActivationDateTime                     : 1/1/0001 12:00:00 AM
#azureADRegistered                         : True
#deviceEnrollmentType                      : appleBulkWithUser
#activationLockBypassCode                  : 
#emailAddress                              : Amy.Kidwell@countryfinancial.com
#azureADDeviceId                           : 7be04976-6260-4cb2-9179-46eb7d0df92c
#deviceRegistrationState                   : registered
#deviceCategoryDisplayName                 : Company Owned
#isSupervised                              : True
#exchangeLastSuccessfulSyncDateTime        : 1/1/0001 12:00:00 AM
#exchangeAccessState                       : none
#exchangeAccessStateReason                 : none
#remoteAssistanceSessionUrl                : 
#remoteAssistanceSessionErrorDetails       : 
#isEncrypted                               : True
#userPrincipalName                         : Amy.Kidwell@countryfinancial.com
#model                                     : iPad Air
#manufacturer                              : Apple
#imei                                      : 353188101406243
#complianceGracePeriodExpirationDateTime   : 12/31/9999 11:59:59 PM
#serialNumber                              : DMPY81RWLMWR
#phoneNumber                               : 
#androidSecurityPatchLevel                 : 
#userDisplayName                           : Amy Kidwell
#configurationManagerClientEnabledFeatures : 
#wiFiMacAddress                            : 5462e210fc4b
#deviceHealthAttestationState              : 
#subscriberCarrier                         : iPad
#meid                                      : 
#totalStorageSpaceInBytes                  : 58435043328
#freeStorageSpaceInBytes                   : 45047873536
#managedDeviceName                         : 0043622f-a342-424d-8d84-a46e2136b7fb_IPad_11/26/2019_10:05 PM
#partnerReportedThreatState                : unknown
#deviceActionResults                       : {}

$execs = "Andrea.Thorpe@countryfinancial.com","Brad.Hildestad@countryfinancial.com","Cara.Dunham@countryfinancial.com","Christie.Weidner@countryfinancial.com","Doyle.Williams@countryfinancial.com","Holly.Moreman@countryfinancial.com","jeffrey.koerner@countryfinancial.com","Jim.Jacobs@countryfinancial.com","Julie.Chilton@countryfinancial.com","Kelvin.Schill@countryfinancial.com","Leeann.Leonard@countryfinancial.com","Lori.McCubbins@countryfinancial.com","Margie.Rock@countryfinancial.com","Miles.Kilcoin@countryfinancial.com","Rachael.Sklamberg@countryfinancial.com","Rob.McDade@countryfinancial.com","Steve.Denault@countryfinancial.com","Tim.Harris@countryfinancial.com","Trisha.McClelland@countryfinancial.com","JVance@ilfb.org","ABender@ilfb.org","alan.dodds@countryfinancial.com","chad.allen@countryfinancial.com","derek.vogler@countryfinancial.com","heather.moore@countryfinancial.com","Andrew.Bender@countryfinancial.com","Kim.fellner@countryfinancial.com"

#ok let's start filtering

#filter by display name AND model
#Get-IntuneManagedDevice | get-msgraphallpages | Where-Object {$_.userDisplayName -eq "Evan Stueve" -and $_.model -like "iphone*"}

#filter by specific phone type and list user name, phone, and OS
#Get-IntuneManagedDevice | get-msgraphallpages | Where-Object {$_.model -like "iphone 5*"} | Select userDisplayName, model, osVersion

#filter by OS and imei
#Get-IntuneManagedDevice | get-msgraphallpages | Where-Object {$_.operatingsystem -eq 'ios' -and $_.imei -eq $Null} | Select userDisplayName, model, osVersion

#filter by Android, show User, Phone model, OS, SP level
#Get-IntuneManagedDevice | get-msgraphallpages | Where-Object {$_.operatingsystem -eq 'Android'} | Select userDisplayName, model, osVersion, androidsecuritypatchlevel
#$Android = Get-IntuneManagedDevice | get-msgraphallpages | Where-Object {$_.operatingsystem -eq 'Android'}
#$android.count

#-Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
#Write-host "Number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan


#ok let's start filtering, but this time better?


$AllDevices = get-intunemanageddevice | get-msgraphallpages
$AllDevices.count

$managedDevices = $alldevices | where-object {$_.managementAgent -eq 'mdm'}
$manageddevices.count       MIGHT NEED TO ADD 'googlecloud' management to this list to catch all devices

$managediosdevices = $manageddevices | where-object {$_.operatingsystem -eq 'ios'}
$managediosdevices.count

$managedandroiddevices = $manageddevices | where-object {$_.operatingsystem -eq 'android'}
$managedandroiddevices.count

$managedios1442 = $managediosdevices | where-object {$_.osversion -eq '14.4.2'}
$managedios1442.count

$managediosbelowOS = $managediosdevices | where-object {$_.osversion -ne '14.4.2'}
$managediosbelowOS.count

$managediosbelowOSuser = $managediosbelowOS | select emailaddress
$managediosbelowosuser.count

#$managediosbelowosuser | export-csv -path .\test.csv
#....worked

#$managediosbelowosuser | where-object {$_.emailaddress -eq "jane.dollins@countryfinancial.com"} | export-csv -path .\test2.csv
#.... worked

#$managedandroiddevices | select osversion, androidsecuritypatchlevel, emailaddress | out-gridview
# ... worked

#$managedandroiddevices | where-object {$_.androidsecuritypatchlevel -lt '2020-11-01'} | select osversion, androidsecuritypatchlevel, emailaddress | out-gridview
# . worked

# $androidbelowSP = $managedandroiddevices | where-object {$_.androidsecuritypatchlevel -lt '2020-11-01'}
# ... worked

# $androidbelowSP | where-object {$_.emailaddress -ne 'z_digitalmobile@countryfinancial.com', 'upsdevices@countryfinancial.com'} | select emailaddress | out-gridview
# ... did not work.. does not filter "out" z_digiatlmobile or upsdevices...

# $androidbelowSP | select emailaddress, osversion, androidsecuritypatchlevel | export-csv .\pstest.csv
#  worked!

#maybe create AD group with export automatically to make it easier to send notification


$managedDevices | where-object {($_.emailaddress -eq "evan.stueve@countryfinancial.com") -or ($_.emailaddress -eq "mara.rakestraw@countryfinancial.com")} | out-gridview
#worked to filter two email address
#might need to filter out execs before i start using the email-only variables


$managedDevices.count
$managedDevicesNoExecs = $managedDevices | where-object {($_.emailaddress -ne "Andrea.Thorpe@countryfinancial.com") -or ($_.emailaddress -ne "Brad.Hildestad@countryfinancial.com") -or ($_.emailaddress -ne "Cara.Dunham@countryfinancial.com") -or ($_.emailaddress -ne "Christie.Weidner@countryfinancial.com") -or ($_.emailaddress -ne "Doyle.Williams@countryfinancial.com") -or ($_.emailaddress -ne "Holly.Moreman@countryfinancial.com") -or ($_.emailaddress -ne "jeffrey.koerner@countryfinancial.com") -or ($_.emailaddress -ne "Jim.Jacobs@countryfinancial.com") -or ($_.emailaddress -ne "Julie.Chilton@countryfinancial.com") -or ($_.emailaddress -ne "Kelvin.Schill@countryfinancial.com") -or ($_.emailaddress -ne "Leeann.Leonard@countryfinancial.com") -or ($_.emailaddress -ne "Lori.McCubbins@countryfinancial.com") -or ($_.emailaddress -ne "Margie.Rock@countryfinancial.com") -or ($_.emailaddress -ne "Miles.Kilcoin@countryfinancial.com") -or ($_.emailaddress -ne "Rachael.Sklamberg@countryfinancial.com") -or ($_.emailaddress -ne "Rob.McDade@countryfinancial.com") -or ($_.emailaddress -ne "Steve.Denault@countryfinancial.com") -or ($_.emailaddress -ne "Tim.Harris@countryfinancial.com") -or ($_.emailaddress -ne "Trisha.McClelland@countryfinancial.com") -or ($_.emailaddress -ne "JVance@ilfb.org") -or ($_.emailaddress -ne "ABender@ilfb.org") -or ($_.emailaddress -ne "alan.dodds@countryfinancial.com") -or ($_.emailaddress -ne "chad.allen@countryfinancial.com") -or ($_.emailaddress -ne "derek.vogler@countryfinancial.com") -or ($_.emailaddress -ne "heather.moore@countryfinancial.com") -or ($_.emailaddress -ne "Andrew.Bender@countryfinancial.com") -or ($_.emailaddress -ne "Kim.fellner@countryfinancial.com")}
$managedDevicesNoExecs.count
$managedDevicesNoExecs | Out-GridView
