Get-DnsServerResourceRecord -ZoneName "dubz-vault.corp" -RRType "A" |
Select-Object `
    HostName,
    @{Name="IP";Expression={$_.RecordData.IPv4Address}} |
Export-Csv "C:\temp\dns-a-records.csv" -NoTypeInformation
