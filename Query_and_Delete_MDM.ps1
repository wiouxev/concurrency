Write-Host "Checking for MDM certificate in computer certificate store"

            # Check&Delete MDM device certificate

            Get-ChildItem 'Cert:\LocalMachine\My\' | ? Issuer -EQ "CN=Microsoft Intune MDM Device CA" | % {

                Write-Host " - Removing Intune certificate $($_.DnsNameList.Unicode)"

                Remove-Item $_.PSPath

            }

            # Obtain current management GUID from Task Scheduler

            $EnrollmentGUID = Get-ScheduledTask | Where-Object { $_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt\*" } | Select-Object -ExpandProperty TaskPath -Unique | Where-Object { $_ -like "*-*-*" } | Split-Path -Leaf

            # Start cleanup process

            if ($EnrollmentGUID) {

                $EnrollmentGUID | % {

                    $GUID = $_

                    Write-Host "Current enrollment GUID detected as $GUID"

                    # Stop Intune Management Exention Agent and CCM Agent services

                    Write-Host "Stopping MDM services"

                    if (Get-Service -Name IntuneManagementExtension -ErrorAction SilentlyContinue) {

                        Write-Host " - Stopping IntuneManagementExtension service..."

                        Stop-Service -Name IntuneManagementExtension

                    }

                    if (Get-Service -Name CCMExec -ErrorAction SilentlyContinue) {

                        Write-Host " - Stopping CCMExec service..."

                        Stop-Service -Name CCMExec

                    }

                    # Remove task scheduler entries

                    Write-Host "Removing task scheduler Enterprise Management entries for GUID - $GUID"

                    Get-ScheduledTask | Where-Object { $_.Taskpath -match $GUID } | Unregister-ScheduledTask -Confirm:$false

                    # delete also parent folder

                    Remove-Item -Path "$env:WINDIR\System32\Tasks\Microsoft\Windows\EnterpriseMgmt\$GUID" -Force

                    $RegistryKeys = "HKLM:\SOFTWARE\Microsoft\Enrollments", "HKLM:\SOFTWARE\Microsoft\Enrollments\Status", "HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked", "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled", "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers", "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts", "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger", "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions"

                    foreach ($Key in $RegistryKeys) {

                        Write-Host "Processing registry key $Key"

                        # Remove registry entries

                        if (Test-Path -Path $Key) {

                            # Search for and remove keys with matching GUID

                            Write-Host " - GUID entry found in $Key. Removing..."

                            Get-ChildItem -Path $Key | Where-Object { $_.Name -match $GUID } | Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

                        }

                    }

                }

}

#clear the Externally Managed key

Set-ItemProperty –Path HKLM:\SOFTWARE\Microsoft\Enrollments -Name ExternallyManaged –Value 0 -Type DWord