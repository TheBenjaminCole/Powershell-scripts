<#
.SYNOPSIS
        WN11-CC-000065 Remediation - Disable Wi-Fi Sense
        Disables automatic connection to suggested open hotspots and shared networks
        by setting AutoConnectAllowedOEM to 0.

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-22
    Last Modified   : 2026-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000065

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000065.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$ValueName = "AutoConnectAllowedOEM"
$DesiredValue = 0

# Ensure registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the required value
Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $DesiredValue -Force

# Refresh group policy
gpupdate /target:computer /force | Out-Null

Write-Host "✅ WN11-CC-000065 remediation complete: Wi-Fi Sense disabled."

# Verification output
Get-ItemProperty -Path $RegPath -Name $ValueName
