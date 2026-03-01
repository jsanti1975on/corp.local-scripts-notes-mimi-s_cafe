# ============================================
# Active Directory Enumeration Export Script
# Author  : Jason Santiago
# Version : 1.1
# Status  : Production / Cyber-Range / CTF-Ready
# ============================================
#
# SYNOPSIS
# --------
# Performs structured Active Directory enumeration and exports
# users, groups, group memberships, and privileged group members
# to CSV format for auditing, baseline validation, and lab analysis.
#
# PURPOSE
# -------
# This script is designed for:
#
# • Blue Team baseline creation
# • Privilege escalation detection
# • File Server Resource Manager (FSRM) planning
# • Share and ACL design validation
# • Capture The Flag (CTF) enumeration practice
# • Cyber-Range infrastructure documentation
#
# The script also generates SHA256 hashes of all exported files
# to provide integrity verification and change detection capability.
#
# ARCHITECTURE NOTES
# ------------------
# • Intended to run from a Writable Domain Controller (RWDC)
# • RODC environments may not return full writable directory data
# • Designed for flat management network lab testing
#
# OUTPUT
# ------
# AD_Users.csv
# AD_Groups.csv
# AD_GroupMembers.csv
# Privileged_<Group>.csv
# AD_Export_Hashes.csv
#
# CHANGE LOG
# ----------
# v1.1
# - Added self-exclusion for hash file to prevent file lock error
# - Improved output formatting
# - Silenced non-critical privilege group errors
#
# ============================================

$ExportPath = "redacted"

if (!(Test-Path $ExportPath)) {
    New-Item -ItemType Directory -Path $ExportPath | Out-Null
}

Write-Host "Exporting AD Users..." -ForegroundColor Cyan

Get-ADUser -Filter * -Properties Enabled,LastLogonDate,PasswordLastSet,MemberOf |
Select-Object Name,
              SamAccountName,
              Enabled,
              LastLogonDate,
              PasswordLastSet |
Export-Csv "$ExportPath\AD_Users.csv" -NoTypeInformation

Write-Host "Exporting AD Groups..." -ForegroundColor Cyan

Get-ADGroup -Filter * |
Select-Object Name,
              GroupScope,
              GroupCategory |
Export-Csv "$ExportPath\AD_Groups.csv" -NoTypeInformation

Write-Host "Exporting Group Memberships..." -ForegroundColor Cyan

Get-ADGroup -Filter * | ForEach-Object {
    $Group = $_.Name
    Get-ADGroupMember $_ |
    Select-Object @{
            Name="Group"
            Expression={$Group}
        },
        Name,
        SamAccountName,
        ObjectClass
} | Export-Csv "$ExportPath\AD_GroupMembers.csv" -NoTypeInformation

Write-Host "Exporting Privileged Groups..." -ForegroundColor Cyan

$PrivGroups = @(
    "Domain Admins",
    "Enterprise Admins",
    "Schema Admins",
    "Administrators",
    "Backup Operators",
    "Account Operators"
)

foreach ($Group in $PrivGroups) {

    Get-ADGroupMember $Group -ErrorAction SilentlyContinue |
    Select-Object @{
            Name="Group"
            Expression={$Group}
        },
        Name,
        SamAccountName,
        ObjectClass |
    Export-Csv "$ExportPath\Privileged_$($Group -replace ' ','_').csv" -NoTypeInformation
}

Write-Host "Generating SHA256 hash..." -ForegroundColor Cyan

Get-ChildItem $ExportPath -Filter *.csv |
Where-Object { $_.Name -ne "AD_Export_Hashes.csv" } |
Get-FileHash -Algorithm SHA256 |
Export-Csv "$ExportPath\AD_Export_Hashes.csv" -NoTypeInformation

Write-Host "Export Complete." -ForegroundColor Green
