
$legalNoticeCaptionPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$legalNoticeTextPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Deleting the entries 1
if (Test-Path $legalNoticeCaptionPath) {
    Set-ItemProperty -Path $legalNoticeCaptionPath -Name "LegalNoticeCaption" -Value $null -Force
    Write-Host "LegalNoticeCaption value deleted from the registry."
} else {
    Write-Host "LegalNoticeCaption value not found in the registry."
}

# Delete the entries 2
if (Test-Path $legalNoticeTextPath) {
    Set-ItemProperty -Path $legalNoticeTextPath -Name "LegalNoticeText" -Value $null -Force
    Write-Host "LegalNoticeText value deleted from the registry."
} else {
    Write-Host "LegalNoticeText value not found in the registry."
}
