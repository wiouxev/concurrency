Remove-Item "$env:windir\system32\GroupPolicy" -Force -Recurse
Remove-Item -Path “HKLM:\Software\Policies\Microsoft” -Force -Recurse
Remove-Item -Path “HKCU:\Software\Policies\Microsoft” -Force -Recurse
Remove-Item -Path “HKCU:\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects” -Force -Recurse
Remove-Item -Path “HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies” -Force -Recurse