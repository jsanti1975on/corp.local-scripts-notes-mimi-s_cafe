Get-DnsServerResourceRecord -ZoneName "your-domain.local" -RRType "A" |
Where-Object {
    $_.Hostname -notmatch "DomainDnsZones|ForestDnsZones" -and
    $_.Hostname -ne "@"
} |
Select-Object `
Hostname,
@{Name="FQDN";Expression={ "$($_.Hostname).your-domain.local" }},
@{Name="IP";Expression={$_.RecordData.IPv4Address}} |
Export-Csv "C:\Users\jsantiago\Desktop\dns-a-records-clean.csv" -NoTypeInformation
