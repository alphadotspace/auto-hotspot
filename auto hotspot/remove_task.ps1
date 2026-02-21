# ============================================================
#  remove_task.ps1
#  Removes the AutoConnectIPhoneHotspot scheduled task.
#  RUN AS ADMINISTRATOR.
# ============================================================

$taskName = "AutoConnectIPhoneHotspot"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n[ERROR] Please run this script as Administrator." -ForegroundColor Red
    pause
    exit 1
}

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "`n[SUCCESS] Automation removed. Your laptop will no longer auto-connect to the hotspot." -ForegroundColor Green
} else {
    Write-Host "`n[INFO] Task '$taskName' was not found — nothing to remove." -ForegroundColor Yellow
}

pause
