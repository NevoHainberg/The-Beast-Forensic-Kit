$TargetInput = Read-Host "Enter Target Hostnames (Comma separated)"
$Targets = $TargetInput.Split(",").Trim()

foreach ($Computer in $Targets) {
    Write-Host "[*] Scanning processes on: $Computer..." -ForegroundColor Cyan
    try {
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            Get-Process | Select-Object Name, Id, Path, Company, Description | Where-Object {$null -eq $_.Company}
        } -ErrorAction Stop | Format-Table -AutoSize
    } catch {
        Write-Host "[!] Failed to connect to $Computer. Ensure WinRM is enabled." -ForegroundColor Red
    }
}