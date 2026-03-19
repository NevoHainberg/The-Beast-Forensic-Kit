$OutFile = ".\DNS_Cache_Dump.csv"

Write-Host "[*] Dumping DNS Client Cache from Local Machine..." -ForegroundColor Cyan

Get-DnsClientCache | Select-Object Name, Type, Status, Data | Export-Csv -Path $OutFile -NoTypeInformation

Write-Host "[V] DNS Cache exported to: $OutFile" -ForegroundColor Green