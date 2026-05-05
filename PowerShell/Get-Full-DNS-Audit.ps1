# ==========================================================
# Full DNS Audit Suite - your-domain.local
# Purpose: Validate A, PTR, SRV, DC locator, and DNS health
# ==========================================================

$Domain      = "your-domain.local"
$ReverseZone = "10.10.10.in-addr.arpa" # Adjust to the subnet
$DnsServer   = "enter-hostname"
$ReportPath  = "C:\Users\jsantiago\Desktop\dns-full-audit-report.csv" # Adjust to your out path 

$Results = @()

Write-Host "`n=== DNS FULL AUDIT STARTED ===" -ForegroundColor Cyan

# ----------------------------------------------------------
# 1. Forward A Record Audit
# ----------------------------------------------------------

Write-Host "`n[1] Checking Forward A Records and PTR Matches..." -ForegroundColor Yellow

$ARecords = Get-DnsServerResourceRecord `
    -ComputerName $DnsServer `
    -ZoneName $Domain `
    -RRType "A" |
Where-Object {
    $_.Hostname -notmatch "DomainDnsZones|ForestDnsZones" -and
    $_.Hostname -ne "@"
}

foreach ($Record in $ARecords) {

    $Hostname = $Record.Hostname
    $FQDN     = "$Hostname.$Domain"
    $IP       = $Record.RecordData.IPv4Address.IPAddressToString
    $PTR      = $null
    $Status   = "OK"

    try {
        $Lookup = Resolve-DnsName $IP -Server $DnsServer -ErrorAction Stop
        $PTR = $Lookup.NameHost.TrimEnd(".")

        if ($PTR -ne $FQDN) {
            $Status = "PTR Mismatch"
        }
    }
    catch {
        $Status = "Missing PTR"
    }

    $Results += [PSCustomObject]@{
        CheckType = "A/PTR"
        Name      = $FQDN
        IP        = $IP
        Result    = $Status
        Details   = "PTR=$PTR"
    }
}

# ----------------------------------------------------------
# 2. Reverse PTR Zone Audit
# ----------------------------------------------------------

Write-Host "[2] Checking Reverse PTR Records..." -ForegroundColor Yellow

try {
    $PTRRecords = Get-DnsServerResourceRecord `
        -ComputerName $DnsServer `
        -ZoneName $ReverseZone `
        -RRType "PTR"

    foreach ($PTRRecord in $PTRRecords) {

        $PTRTarget = $PTRRecord.RecordData.PtrDomainName.TrimEnd(".")
        $PTRHost   = $PTRRecord.HostName

        $Results += [PSCustomObject]@{
            CheckType = "PTR"
            Name      = $PTRHost
            IP        = ""
            Result    = "Found"
            Details   = $PTRTarget
        }
    }
}
catch {
    $Results += [PSCustomObject]@{
        CheckType = "PTR"
        Name      = $ReverseZone
        IP        = ""
        Result    = "Error"
        Details   = $_.Exception.Message
    }
}

# ----------------------------------------------------------
# 3. SRV Record Audit
# ----------------------------------------------------------

Write-Host "[3] Checking AD SRV Records..." -ForegroundColor Yellow

$SrvChecks = @(
    "_ldap._tcp.dc._msdcs.$Domain",
    "_kerberos._tcp.dc._msdcs.$Domain",
    "_ldap._tcp.$Domain",
    "_kerberos._tcp.$Domain",
    "_gc._tcp.$Domain"
)

foreach ($Srv in $SrvChecks) {
    try {
        $SrvResult = Resolve-DnsName $Srv -Type SRV -Server $DnsServer -ErrorAction Stop

        foreach ($Item in $SrvResult) {
            $Results += [PSCustomObject]@{
                CheckType = "SRV"
                Name      = $Srv
                IP        = ""
                Result    = "OK"
                Details   = "Target=$($Item.NameTarget) Port=$($Item.Port)"
            }
        }
    }
    catch {
        $Results += [PSCustomObject]@{
            CheckType = "SRV"
            Name      = $Srv
            IP        = ""
            Result    = "Missing/Failed"
            Details   = $_.Exception.Message
        }
    }
}

# ----------------------------------------------------------
# 4. NS Record Audit
# ----------------------------------------------------------

Write-Host "[4] Checking Name Server Records..." -ForegroundColor Yellow

try {
    $NSRecords = Resolve-DnsName $Domain -Type NS -Server $DnsServer -ErrorAction Stop

    foreach ($NS in $NSRecords) {
        $Results += [PSCustomObject]@{
            CheckType = "NS"
            Name      = $Domain
            IP        = ""
            Result    = "OK"
            Details   = "NS=$($NS.NameHost)"
        }
    }
}
catch {
    $Results += [PSCustomObject]@{
        CheckType = "NS"
        Name      = $Domain
        IP        = ""
        Result    = "Failed"
        Details   = $_.Exception.Message
    }
}

# ----------------------------------------------------------
# 5. DC Locator Test
# ----------------------------------------------------------

Write-Host "[5] Checking DC Locator..." -ForegroundColor Yellow

try {
    $DCs = nltest /dsgetdc:$Domain 2>&1

    $Results += [PSCustomObject]@{
        CheckType = "DC Locator"
        Name      = $Domain
        IP        = ""
        Result    = "Ran"
        Details   = ($DCs -join " | ")
    }
}
catch {
    $Results += [PSCustomObject]@{
        CheckType = "DC Locator"
        Name      = $Domain
        IP        = ""
        Result    = "Failed"
        Details   = $_.Exception.Message
    }
}

# ----------------------------------------------------------
# 6. DCDIAG DNS Test
# ----------------------------------------------------------

Write-Host "[6] Running DCDIAG DNS Test..." -ForegroundColor Yellow

try {
    $DcDiag = dcdiag /test:dns /v 2>&1

    $Results += [PSCustomObject]@{
        CheckType = "DCDIAG"
        Name      = $DnsServer
        IP        = ""
        Result    = "Ran"
        Details   = ($DcDiag | Select-String "passed test|failed test|error|warning" | Out-String).Trim()
    }
}
catch {
    $Results += [PSCustomObject]@{
        CheckType = "DCDIAG"
        Name      = $DnsServer
        IP        = ""
        Result    = "Failed"
        Details   = $_.Exception.Message
    }
}

# ----------------------------------------------------------
# 7. Export Report
# ----------------------------------------------------------

$Results | Format-Table -AutoSize

$Results | Export-Csv $ReportPath -NoTypeInformation

Write-Host "`n=== DNS FULL AUDIT COMPLETE ===" -ForegroundColor Green
Write-Host "Report saved to: $ReportPath" -ForegroundColor Green
