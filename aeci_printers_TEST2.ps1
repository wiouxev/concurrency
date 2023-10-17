## AECI printer script test 2
## TESTING
## TESTING

Start-Transcript -Path $(Join-Path $env:temp "PrinterMapping.log")

set-executionpolicy Bypass -Scope Process

Add-Printer -ConnectionName \\HQ-PRTSRV01-PRD\p-hq-30-4505

## [Start] Alternative connection method
### Add-PrinterPort -Name "IP_10.8.61.116" -PrinterHostAddress "10.8.61.116"
## Add printer driver if required
### Add-PrinterDriver -DriverName "Canon Generic Plus UFR II"
## Add-Printer -Name "P-HQ-30-4505" -DriverName "Canon Generic Plus UFR II" -PortName "IP_10.8.61.116"
## [End] Alternative connection method


## printer model: Toshiba e-STUDIO 4505AC
## IP address: 10.8.61.116. 
## network share: \\HQ-PRTSRV01-PRD\p-hq-30-4505


Stop-Transcript