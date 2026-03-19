$OutFile = ".\Scheduled_Tasks_Export.csv"

Write-Host "[*] Auditing Scheduled Tasks on Local Machine..." -ForegroundColor Cyan

$Tasks = Get-ScheduledTask | Where-Object {$_.State -ne "Disabled"}

$Results = foreach ($Task in $Tasks) {
    $Action = $Task.Actions | Select-Object -First 1
    
    [PSCustomObject]@{
        TaskName      = $Task.TaskName
        TaskPath      = $Task.TaskPath
        State         = $Task.State
        Author        = $Task.Author
        # Extracting the actual command or script being executed
        ExecutePath   = $Action.Execute
        Arguments     = $Action.Arguments
        ScriptPath    = $Action.Script
        LastRunTime   = (Get-ScheduledTaskInfo -TaskName $Task.TaskName -TaskPath $Task.TaskPath).LastRunTime
    }
}

$Results | Export-Csv -Path $OutFile -NoTypeInformation
Write-Host "[V] Audit complete. Results exported to: $OutFile" -ForegroundColor Green