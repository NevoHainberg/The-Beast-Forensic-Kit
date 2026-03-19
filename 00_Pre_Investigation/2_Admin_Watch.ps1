$Groups = @("Domain Admins", "Enterprise Admins", "Schema Admins")
$OutFile = ".\Privileged_Group_Audit.txt"

Write-Host "[*] Auditing Privileged Group Membership..." -ForegroundColor Cyan
"--- Privileged Group Audit - $(Get-Date) ---" | Out-File $OutFile

foreach ($Group in $Groups) {
    "`r`n--- Group: $Group ---" | Out-File $OutFile -Append
    try {
        Get-ADGroupMember -Identity $Group | Select-Object Name, SamAccountName, DistinguishedName | Out-File $OutFile -Append
    } catch {
        "Error: Could not retrieve members for $Group" | Out-File $OutFile -Append
    }
}

Write-Host "[V] Audit complete. Results exported to: $OutFile" -ForegroundColor Green