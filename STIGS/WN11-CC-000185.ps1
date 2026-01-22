<#
.SYNOPSIS
    Remediates WN11-CC-000185 - Disables AutoRun on Windows 11

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-21
    Last Modified   : 2026-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000185

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000185.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoAutorun"
$DesiredValue = 1

try {
    # Ensure registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set NoAutorun to 1
    New-ItemProperty `
        -Path $RegPath `
        -Name $ValueName `
        -PropertyType DWORD `
        -Value $DesiredValue `
        -Force | Out-Null

    Write-Output "SUCCESS: AutoRun disabled (WN11-CC-000185)."
}
catch {
    Write-Error "FAILED: Unable to remediate WN11-CC-000185. Error details: $_"
}
