<#
.SYNOPSIS
    Remediates STIG WN11-CC-000197 by disabling Microsoft consumer experiences.
    Sets the registry value:
    HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\DisableWindowsConsumerFeatures = 1

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-21
    Last Modified   : 2026-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000197

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000197.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$ValueName = "DisableWindowsConsumerFeatures"
$DesiredValue = 1

try {
    # Ensure registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set required registry value
    New-ItemProperty `
        -Path $RegPath `
        -Name $ValueName `
        -PropertyType DWORD `
        -Value $DesiredValue `
        -Force | Out-Null

    Write-Output "SUCCESS: Microsoft consumer experiences disabled (WN11-CC-000197)."
}
catch {
    Write-Error "FAILED: Unable to remediate WN11-CC-000197. Error details: $_"
}
