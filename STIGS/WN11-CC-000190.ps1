<#
.SYNOPSIS
    WN11-CC-000190 Remediation - Disable AutoPlay on all drives
    Sets the NoDriveTypeAutoRun registry value to 255 (0xFF) to disable AutoPlay on all drives.
    Updates Local Group Policy store for GPEDIT visibility.

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-22
    Last Modified   : 2026-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000190

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000190.ps1
#>
<#
.SYNOPSIS
    WN11-CC-000190 Remediation - Disable AutoPlay on all drives
.DESCRIPTION
    Sets the NoDriveTypeAutoRun registry value to 255 (0xFF) to disable AutoPlay on all drives.
    Updates Local Group Policy store for GPEDIT visibility.
#>

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoDriveTypeAutoRun"
$DesiredValue = 0xFF  # 255 decimal

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the NoDriveTypeAutoRun value
Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $DesiredValue -Force

# refresh Group Policy to ensure GUI updates
gpupdate /target:computer /force | Out-Null

Write-Host "WN11-CC-000190 remediation complete: AutoPlay disabled on all drives."

# Verification
Get-ItemProperty -Path $RegPath -Name $ValueName
