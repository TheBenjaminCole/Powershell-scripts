<#
.SYNOPSIS
    WN11-CC-000305 – Disable indexing of encrypted files

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-22
    Last Modified   : 2026-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000305

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000305.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$RegName = "AllowIndexingEncryptedStoresOrItems"
$DesiredValue = 0

# Create the key if it doesn't exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the value
Set-ItemProperty -Path $RegPath -Name $RegName -Value $DesiredValue -Type DWord

# Verify
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegName | Select-Object -ExpandProperty $RegName

if ($CurrentValue -eq $DesiredValue) {
    Write-Output "SUCCESS: Indexing of encrypted files disabled (WN11-CC-000305)."
} else {
    Write-Output "FAIL: Could not disable indexing of encrypted files (WN11-CC-000305)."
}
