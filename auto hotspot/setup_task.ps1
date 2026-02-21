# setup_task.ps1
# Registers connect_hotspot.ps1 to run automatically at every login.
# Auto-relaunches itself as Administrator if needed.

# Self-elevate if not running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$taskName = "AutoConnectIPhoneHotspot"
$scriptPath = Join-Path $PSScriptRoot "connect_hotspot.ps1"
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

Write-Host ""
Write-Host "Setting up Auto Hotspot Connect task..." -ForegroundColor Cyan

# Remove existing task if present
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Removed old task." -ForegroundColor Yellow
}

# Action: run the PS script hidden
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""

# Trigger: at user logon
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser

# Settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5)

# Register
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -RunLevel Highest `
    -Force | Out-Null

Write-Host ""
Write-Host "[SUCCESS] Done! The hotspot will now auto-connect every time you log in." -ForegroundColor Green
Write-Host ""
Write-Host "To remove it later, run: remove_task.ps1" -ForegroundColor Gray
Write-Host ""
pause
