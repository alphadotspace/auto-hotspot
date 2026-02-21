# connect_hotspot.ps1
# Full automation: triggers iPhone hotspot via Bluetooth, then connects WiFi.
#
# HOW IT WORKS:
#   1. Windows reconnects Bluetooth to your iPhone on startup
#   2. iPhone Shortcuts detects Bluetooth connection -> turns on hotspot
#   3. This script waits, then connects Windows to the hotspot WiFi
#
# ONE-TIME SETUP REQUIRED ON IPHONE:
#   See IPHONE_SETUP.md in this folder for step-by-step instructions.

# ---------------------------------------------------------------
# SETTINGS - change these to match your setup
# ---------------------------------------------------------------

# Your iPhone hotspot WiFi name (Settings > General > About > Name)
$hotspotName = "Rakeshhh"

# Seconds to wait for iPhone to enable hotspot after Bluetooth triggers
# (keep at 15-20 seconds to give the iPhone Shortcut time to run)
$hotspotWarmupWait = 18

# Startup delay before the script begins (gives Windows time to settle)
$startupDelay = 10

# How many times to retry WiFi connection
$maxRetries = 6

# Seconds between retries
$retryInterval = 8

# ---------------------------------------------------------------

$logFile = "$PSScriptRoot\hotspot_log.txt"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp  $Message"
}

Start-Sleep -Seconds $startupDelay
Write-Log "=== Auto Hotspot started ==="

# ------- STEP 1: Wait for iPhone hotspot to enable -------
# Windows auto-reconnects Bluetooth to your paired iPhone at startup.
# The iPhone Shortcuts automation detects this and turns the hotspot on.
# We just wait for that to happen before trying WiFi.
Write-Log "Waiting $hotspotWarmupWait seconds for iPhone hotspot to enable..."
Start-Sleep -Seconds $hotspotWarmupWait

# ------- STEP 2: Check if already connected -------
$currentWifi = (netsh wlan show interfaces | Select-String "SSID\s+:" | Select-Object -First 1) -replace ".*SSID\s+:\s+", ""
if ($currentWifi.Trim() -eq $hotspotName) {
    Write-Log "Already connected to $hotspotName. Done."
    exit 0
}

# ------- STEP 3: Check saved WiFi profile -------
$profileExists = netsh wlan show profiles | Select-String $hotspotName
if (-not $profileExists) {
    Write-Log "ERROR: No saved WiFi profile for '$hotspotName'."
    Write-Log "Connect to the hotspot manually once first so Windows saves the profile."
    exit 1
}

# ------- STEP 4: Connect with retries -------
for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
    Write-Log "WiFi connect attempt $attempt of $maxRetries..."

    netsh wlan connect name="$hotspotName" 2>&1 | Out-Null
    Start-Sleep -Seconds 5

    $connected = (netsh wlan show interfaces | Select-String "SSID\s+:" | Select-Object -First 1) -replace ".*SSID\s+:\s+", ""

    if ($connected.Trim() -eq $hotspotName) {
        Write-Log "SUCCESS: Connected to $hotspotName"

        # Desktop notification
        Add-Type -AssemblyName System.Windows.Forms
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Information
        $notify.Visible = $true
        $notify.ShowBalloonTip(4000, "Hotspot Connected", "Connected to $hotspotName", [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 5
        $notify.Dispose()
        exit 0
    }

    Write-Log "Not connected yet. Waiting $retryInterval seconds..."
    Start-Sleep -Seconds $retryInterval
}

Write-Log "FAILED: Could not connect to $hotspotName after $maxRetries attempts."
Write-Log "Check that iPhone Shortcuts automation is set up (see IPHONE_SETUP.md)."
