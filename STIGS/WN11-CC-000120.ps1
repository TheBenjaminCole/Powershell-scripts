<#
.SYNOPSIS
Remediates STIG WN11-CC-000120: Hide network selection UI at logon

.DESCRIPTION
- Sets the registry value to hide the network selection UI at Windows logon
- Forces a Group Policy update

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-22
    Last Modified   : 2026-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000120

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000120.ps1
#>

# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You must run this script as Administrator."
    exit
}

Write-Host "Setting DontDisplayNetworkSelectionUI to 1..."

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Create key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the DWORD value
Set-ItemProperty -Path $regPath -Name "DontDisplayNetworkSelectionUI" -Value 1 -Type DWord

Write-Host "Updating Group Policy..."
gpupdate /force | Out-Null

Write-Host "WN11-CC-000120 remediation completed. Reboot may be required to fully apply changes."
