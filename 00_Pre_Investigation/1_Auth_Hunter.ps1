$OutFile = ".\DC_Auth_Audit.csv"
$DaysBack = 1

Write-Host "[*] Auditing Remote Logons (Event 4624) - Last $DaysBack Day(s)..." -ForegroundColor Cyan

$Events = Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624;StartTime=(Get-Date).AddDays(-$DaysBack)} -ErrorAction SilentlyContinue

if ($null -eq $Events) {
    Write-Host "[!] No events found for the specified timeframe." -ForegroundColor Yellow
    exit
}

$Results = foreach ($Event in $Events) {
    [xml]$xml = $Event.ToXml()
    $EventData = $xml.Event.EventData.Data
    
    [PSCustomObject]@{
        Time          = $Event.TimeCreated
        UserName      = ($EventData | Where-Object {$_.Name -eq "TargetUserName"}).'#text'
        LogonType     = ($EventData | Where-Object {$_.Name -eq "LogonType"}).'#text' 
        SourceIP      = ($EventData | Where-Object {$_.Name -eq "IpAddress"}).'#text'
        TargetMachine = $env:COMPUTERNAME
    }
}

$Results | Where-Object {$_.SourceIP -ne "-" -and $_.SourceIP -ne "127.0.0.1"} | Export-Csv -Path $OutFile -NoTypeInformation
Write-Host "[V] Audit complete. Results exported to: $OutFile" -ForegroundColor Green