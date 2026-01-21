<#
.SYNOPSIS
        Remediates STIG WN11-CC-000315 by disabling "Always install with elevated privileges".

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-21
    Last Modified   : 2026-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000315

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000315.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName = "AlwaysInstallElevated"
$DesiredValue = 0

try {
    # Ensure the registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set the registry value
    New-ItemProperty `
        -Path $RegPath `
        -Name $ValueName `
        -PropertyType DWORD `
        -Value $DesiredValue `
        -Force | Out-Null

    Write-Output "SUCCESS: '$ValueName' set to '$DesiredValue' under '$RegPath'."
}
catch {
    Write-Error "FAILED: Unable to remediate WN11-CC-000315. Error details: $_"
}
