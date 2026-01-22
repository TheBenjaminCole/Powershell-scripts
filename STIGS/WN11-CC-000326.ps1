<#
.SYNOPSIS
    Remediates STIG WN11-CC-000326 by enabling PowerShell Script Block Logging.
    Sets the registry value:
    HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockLogging = 1

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-21
    Last Modified   : 2026-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000326

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000326.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$ValueName = "EnableScriptBlockLogging"
$DesiredValue = 1

try {
    # Ensure registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set Script Block Logging
    New-ItemProperty `
        -Path $RegPath `
        -Name $ValueName `
        -PropertyType DWORD `
        -Value $DesiredValue `
        -Force | Out-Null

    Write-Output "SUCCESS: PowerShell Script Block Logging enabled (WN11-CC-000326)."
}
catch {
    Write-Error "FAILED: Unable to remediate WN11-CC-000326. Error details: $_"
}
