<#
.SYNOPSIS
        Remediates STIG WN11-CC-000327 by enabling PowerShell Transcription 

.NOTES
    Author          : Benjamin Cole
    LinkedIn        : linkedin.com/in/thebenjamincole/
    GitHub          : github.com/thebenjamincole
    Date Created    : 2026-01-21
    Last Modified   : 2026-01-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000327

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    **Run as administrator
    PS C:\> .\WN11-CC-000327.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$TranscriptDir = "C:\PowerShell_Transcripts"

# Ensure registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Enable PowerShell Transcription
Set-ItemProperty `
    -Path $RegPath `
    -Name "EnableTranscripting" `
    -Type DWord `
    -Value 1

# Set transcript output directory
Set-ItemProperty `
    -Path $RegPath `
    -Name "OutputDirectory" `
    -Type String `
    -Value $TranscriptDir

# Create transcript directory if it doesn't exist
if (-not (Test-Path $TranscriptDir)) {
    New-Item -Path $TranscriptDir -ItemType Directory | Out-Null
}

Write-Host "PowerShell Transcription has been enabled and configured."
