<#
.SYNOPSIS
    Enables or disables legacy cryptographic protocols (secure vs insecure) on the system.
    Test in a non-production environment prior to broad deployment.
    Must be executed with administrative privileges.

.NOTES
    Author        : Benjamin Cole
    Date Created  : 2026-01-06
    Last Modified : 2026-01-06
    Version       : 1.0

.TESTED ON
    Date(s) Tested  : 2026-01-06
    Tested By       : Benjamin Cole
    Systems Tested  : Windows Server 2025 Datacenter (Build 1809)
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Set $secureMode = $true to harden the system
    Example:
    PS C:\> .\Set-CryptoProtocols.ps1
#>

# Toggle secure vs legacy protocol configuration
$secureMode = $true

# Verify script is running with elevated privileges
function Test-Admin {
    $currentIdentity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentIdentity)
    $currentPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Error "Administrator privileges are required to modify cryptographic settings."
    exit 1
}

# Helper function to configure protocol settings
function Set-ProtocolState {
    param (
        [string]$ServerKeyPath,
        [string]$ClientKeyPath,
        [bool]$EnableProtocol,
        [string]$ProtocolName
    )

    $enabledValue  = if ($EnableProtocol) { 1 } else { 0 }
    $disabledValue = if ($EnableProtocol) { 0 } else { 1 }

    New-Item -Path $ServerKeyPath -Force | Out-Null
    New-ItemProperty -Path $ServerKeyPath -Name 'Enabled' -Value $enabledValue -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $ServerKeyPath -Name 'DisabledByDefault' -Value $disabledValue -PropertyType DWord -Force | Out-Null

    New-Item -Path $ClientKeyPath -Force | Out-Null
    New-ItemProperty -Path $ClientKeyPath -Name 'Enabled' -Value $enabledValue -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $ClientKeyPath -Name 'DisabledByDefault' -Value $disabledValue -PropertyType DWord -Force | Out-Null

    Write-Host "$ProtocolName configuration updated."
}

# SSL 2.0
Set-ProtocolState `
    -ServerKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" `
    -ClientKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" `
    -EnableProtocol (-not $secureMode) `
    -ProtocolName "SSL 2.0"

# SSL 3.0
Set-ProtocolState `
    -ServerKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" `
    -ClientKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" `
    -EnableProtocol (-not $secureMode) `
    -ProtocolName "SSL 3.0"

# TLS 1.0
Set-ProtocolState `
    -ServerKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" `
    -ClientKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" `
    -EnableProtocol (-not $secureMode) `
    -ProtocolName "TLS 1.0"

# TLS 1.1
Set-ProtocolState `
    -ServerKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" `
    -ClientKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" `
    -EnableProtocol (-not $secureMode) `
    -ProtocolName "TLS 1.1"

# TLS 1.2
Set-ProtocolState `
    -ServerKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" `
    -ClientKeyPath "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" `
    -EnableProtocol $secureMode `
    -ProtocolName "TLS 1.2"

Write-Host "Protocol configuration complete. A system reboot is required for changes to take effect."
