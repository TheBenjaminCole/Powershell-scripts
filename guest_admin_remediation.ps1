<#
.SYNOPSIS
    Toggles guest account Administrators group membership (add vs remove) on the system.
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

.USAGE
    Set [$AddGuestToAdminGroup = $False] to secure the system
    Example syntax:
    PS C:\> .\toggle-guest-local-administrators.ps1 
 #>


# Toggle behavior
$AddGuestToAdminGroup = $False

$LocalAdminGroup = "Administrators"
$GuestAccount = "Guest"

function Is-GuestInAdminGroup {
    $members = net localgroup $LocalAdminGroup
    return $members -match "^\s*$GuestAccount\s*$"
}

if ($AddGuestToAdminGroup) {
    if (-not (Is-GuestInAdminGroup)) {
        net localgroup $LocalAdminGroup $GuestAccount /add
        Write-Output "Guest account added to Administrators group."
    } else {
        Write-Output "Guest account is already a member of Administrators."
    }
}
else {
    if (Is-GuestInAdminGroup) {
        net localgroup $LocalAdminGroup $GuestAccount /delete
        Write-Output "Guest account removed from Administrators group."
    } else {
        Write-Output "Guest account is not a member of Administrators."
    }
}
