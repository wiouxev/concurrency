## AECI printer script - HQ

Start-Transcript -Path $(Join-Path $env:temp "PrinterMapping.log")
set-executionpolicy Bypass -Scope Process

Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-00-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-10-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-20-2150
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-20-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-30-2660
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-30-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-40-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-40-4515
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-50-3555-2
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-50-3555-3
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-50-4505
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-50-M479
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-60-4515
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-60-iPF765
Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\P-HQ-AF-PROCUREMENT




## [Start] Alternative connection method
### Add-PrinterPort -Name "IP_10.8.61.116" -PrinterHostAddress "10.8.61.116"
## Add printer driver if required
### Add-PrinterDriver -DriverName "Canon Generic Plus UFR II"
## Add-Printer -Name "P-HQ-30-4505" -DriverName "Canon Generic Plus UFR II" -PortName "IP_10.8.61.116"
## [End] Alternative connection method
##


Stop-Transcript




## Begin total printer list for HQ ## Print Server HQ-PRTSRV01-PRD ##
## P-HQ-00-2660
## P-HQ-00-3130
## P-HQ-00-4505
## P-HQ-00-5217
## P-HQ-00-5344
## P-HQ-00-M454
## P-HQ-00-M479
## P-HQ-10-1320
## P-HQ-10-2660
## P-HQ-10-4505
## P-HQ-10-7760
## P-HQ-20-1135-S
## P-HQ-20-1606
## P-HQ-20-2015
## P-HQ-20-2150
## P-HQ-20-2660-T
## P-HQ-20-4505
## P-HQ-20-5290
## P-HQ-20-5293
## P-HQ-20-5550
## P-HQ-20-E556
## P-HQ-20-M277
## P-HQ-20-M401
## P-HQ-20-M452
## P-HQ-30-2660
## P-HQ-30-4505
## P-HQ-40-2107
## P-HQ-40-425
## P-HQ-40-4505
## P-HQ-40-4515
## P-HQ-40-5245
## P-HQ-40-5291
## P-HQ-40-5324
## P-HQ-40-5332
## P-HQ-40-5333
## P-HQ-40-5339
## P-HQ-40-5903
## P-HQ-40-M148-219
## P-HQ-50-2660-E
## P-HQ-50-2660-W
## P-HQ-50-3555-2
## P-HQ-50-3555-3
## P-HQ-50-4505
## P-HQ-50-M454
## P-HQ-50-M479
## P-HQ-60-2660-se
## P-HQ-60-4515
## P-HQ-60-5228
## P-HQ-60-iPF765
## P-HQ-60-M148-F1
## P-HQ-60-M454
## P-HQ-AF-PROCUREMENT
## End total printer list for HQ ##

