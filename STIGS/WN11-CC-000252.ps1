<#
.SYNOPSIS
    WN11-CC-000252 Remediation - Disable Windows Game Recording and Broadcasting
    Sets the AllowGameDVR registry value to 0 to disable GameDVR, preventing unintended screen recording.

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-22
    Last Modified   : 2026-01-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000252

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000252.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
$ValueName = "AllowGameDVR"
$DesiredValue = 0

# 1️⃣ Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# 2️⃣ Set AllowGameDVR to 0
Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $DesiredValue -Force

# 3️⃣ Optional: refresh Group Policy
gpupdate /target:computer /force | Out-Null

Write-Host "✅ WN11-CC-000252 remediation complete: GameDVR disabled."

# 4️⃣ Verification (optional)
Get-ItemProperty -Path $RegPath -Name $ValueName
