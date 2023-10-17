<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: Create-ShortcutFile
Description:
Create the Lnk shortcut file
Release notes:
Version 1.0: Init
#> 


function Create-WebShortcut {
    param (
        [Parameter(Mandatory)]
        [String] $Path,
        [Parameter()]
        [String] $WebsiteUrl,
        [Parameter()]
        [String] $Icon
    )

    #Edge
    $edgePath = "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"


    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($Path)
    $Shortcut.TargetPath = $edgePath
    $Shortcut.Arguments = $WebsiteUrl
    $Shortcut.IconLocation = $Icon
    $Shortcut.Save()
    [Runtime.InteropServices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}

## ImageSite ##
#Name of the shortcut
$shortcutName = "ImageSite"
#Icon file best to use a website
$icon = "C:\temp\imagesite.ico"
#Link of the webseite
$websiteUrl = "https://aeci.engine-box.com/sso"
#OutputFolder
$outputFolder = "C:\Users\estueve\OneDrive - Concurrency, Inc\Clients\AECI\desktop shortcuts"



$path = Join-Path -Path $outputFolder -ChildPath "$shortcutName.lnk"

#Create shortcut
Create-WebShortcut -Path $path -WebsiteUrl $websiteUrl -Icon $icon

