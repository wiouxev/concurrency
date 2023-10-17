#Import-Module .\Microsoft.Graph.Intune.psd1
#Connect-MSGraph
$AllVPPApps = (Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("#microsoft.graph.iosVppApp")}) 
 
Foreach ($AllVPPApp in $AllVPPApps)
{

if ([string]::IsNullOrEmpty($AllVPPApp.owner)) 
  
  
  {
$AllVPPApp | Update-DeviceAppManagement_MobileApps -owner $AllVPPApp.vppTokenAppleId
  }




}

#dumps out list of apps and what VPP account is assigned foreach
#Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("#microsoft.graph.iosVppApp") } | Select-Object displayName, owner, vppTokenAppleId
#verified partially working. Run first part and end part to get a list and its owners