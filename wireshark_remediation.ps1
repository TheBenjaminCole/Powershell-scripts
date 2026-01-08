<#
.SYNOPSIS
    Uninstalls Wireshark from the system executing the script.
    Tested on Wireshark Version 2.2.1 (v2.2.1-0-ga6fbd27 from master-2.2).
    Please test thoroughly in a non-production environment before deploying widely.
    Make sure to run as Administrator or with appropriate privileges.

.NOTES
    Author        : Benjamin Cole
    Date Created  : 2026-01-06
    Last Modified : 2026-01-06
    Version       : 1.0

.TESTED ON
    Date(s) Tested  : 2026-01-06
    Tested By       : Benjamin Cole
    Systems Tested  : Windows Server 2025 Datacenter, Build 1809
    PowerShell Ver. : 5.1.17763.6189
    Wireshark Ver.  : 2.2.1 (v2.2.1-0-ga6fbd27 from master-2.2)

.USAGE
    Example syntax:
    PS C:\> .\remediation-wireshark-uninstall.ps1 
#>
 

Write-Output "=== Starting Wireshark Full Removal ==="

# Stop Wireshark if running
Get-Process wireshark -ErrorAction SilentlyContinue | Stop-Process -Force

# Registry paths to check
$uninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Find all Wireshark entries
$apps = Get-ItemProperty $uninstallKeys -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "Wireshark*" }

foreach ($app in $apps) {
    Write-Output "Found: $($app.DisplayName)"

    if ($app.UninstallString -match "msiexec") {
        $guid = ($app.UninstallString -replace '.*\{','{' -replace '\}.*','}')
        Write-Output "Uninstalling MSI $guid"
        Start-Process msiexec.exe -ArgumentList "/x $guid /qn /norestart" -Wait
    }
    else {
        Write-Output "Uninstalling via EXE"
        Start-Process "cmd.exe" -ArgumentList "/c `"$($app.UninstallString)`" /S" -Wait
    }
}

# Remove leftover folders
$paths = @(
    "C:\Program Files\Wireshark",
    "C:\Program Files (x86)\Wireshark",
    "$env:LOCALAPPDATA\Programs\Wireshark",
    "$env:LOCALAPPDATA\Wireshark"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Output "Removing leftover folder: $path"
        Remove-Item $path -Recurse -Force
    }
}

# Remove installer if desired
$installer = "C:\Users\bcole\Downloads\Wireshark-win64-2.2.1.exe"
if (Test-Path $installer) {
    Write-Output "Removing installer file"
    Remove-Item $installer -Force
}

Write-Output "=== Wireshark removal complete ==="
