<#
.SYNOPSIS
    Configures SSL/TLS cipher suite ordering based on security posture.
    Intended for controlled environments with proper change approval.

.NOTES
    Author        : Benjamin Cole
    Date Created  : 2026-01-06
    Last Modified : 2026-01-06
    Version       : 1.1

.TESTED ON
    Systems Tested  : Windows Server 2025 Datacenter (1809)
    PowerShell Ver. : 5.1

.USAGE
    Set $secureEnvironment = $true to enforce secure cipher ordering
    Example:
    PS C:\> .\set-cipher-suite-order.ps1
#>

# Toggle secure vs legacy-compatible configuration
$secureEnvironment = $true

# Registry paths
$SslBasePath   = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL"
$CipherKeyPath = "$SslBasePath\00010002"
$CipherValue   = "Functions"

# Secure cipher suite baseline
$SecureCipherList = @(
    "TLS_AES_256_GCM_SHA384",
    "TLS_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256"
) -join ','

# Legacy-inclusive cipher list
$LegacyCipherList = "$SecureCipherList," + @(
    "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
    "TLS_RSA_WITH_RC4_128_SHA",
    "SSL_RSA_WITH_RC4_128_MD5",
    "TLS_RSA_EXPORT_WITH_RC4_40_MD5"
) -join ','

# Ensure registry structure exists
if (-not (Test-Path $CipherKeyPath)) {
    New-Item -Path $CipherKeyPath -Force | Out-Null
}

# Select cipher configuration
if ($secureEnvironment) {
    Write-Output "Applying secure cipher suite baseline..."
    $SelectedCiphers = $SecureCipherList
} else {
    Write-Output "Applying legacy-compatible cipher suite baseline..."
    $SelectedCiphers = $LegacyCipherList
}

# Apply cipher suite ordering
Set-ItemProperty -Path $CipherKeyPath -Name $CipherValue -Value $SelectedCiphers
Set-ItemProperty -Path $CipherKeyPath -Name "Enabled" -Value 1

# Validation output
Write-Output "Configured cipher suite order:"
(Get-ItemProperty -Path $CipherKeyPath -Name $CipherValue).$CipherValue

Write-Output "System restart required for changes to take effect."
