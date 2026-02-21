# 📶 Auto Hotspot Connect — Windows + iPhone

Automatically connects your Windows laptop to your iPhone's Personal Hotspot **every time you log in** — no manual steps required.

Works by combining:
- **Windows Task Scheduler** to run a script at login
- **iPhone Shortcuts** to auto-enable the hotspot when Bluetooth connects
- **PowerShell** to connect Windows to the hotspot Wi-Fi

---

## ✨ How It Works

```
Laptop starts
    │
    ▼
Windows auto-reconnects Bluetooth to iPhone
    │
    ▼
iPhone Shortcuts detects Bluetooth → turns ON Personal Hotspot
    │
    ▼
connect_hotspot.ps1 waits, then connects Windows to the hotspot Wi-Fi
    │
    ▼
🎉 You're online — automatically!
```

---

## 📁 Files

| File | Description |
|---|---|
| `connect_hotspot.ps1` | Main script — waits for hotspot and connects Wi-Fi |
| `setup_task.ps1` | Registers the script as a Windows Task Scheduler job |
| `remove_task.ps1` | Removes the scheduled task |
| `IPHONE_SETUP.md` | Step-by-step iPhone Shortcuts setup guide |

---

## 🚀 Setup

### Step 1 — iPhone Setup (one-time)
Follow the instructions in **[IPHONE_SETUP.md](IPHONE_SETUP.md)** to:
1. Pair your iPhone and laptop via Bluetooth
2. Create an iPhone Shortcut that turns on the hotspot when Bluetooth connects

### Step 2 — Connect to Hotspot Manually (one-time)
Connect to your iPhone hotspot **once manually** so Windows saves the Wi-Fi profile.

### Step 3 — Run the Setup Script
Right-click `setup_task.ps1` → **Run with PowerShell**

It will automatically ask for Administrator permission and register the task.

> That's it! From now on, every time you log into Windows, the hotspot will connect automatically.

---

## ⚙️ Configuration

Open `connect_hotspot.ps1` and edit the settings at the top:

```powershell
# Your iPhone hotspot Wi-Fi name (Settings > General > About > Name)
$hotspotName = "YourIPhoneName"

# Seconds to wait for hotspot to enable after Bluetooth connects (default: 18)
$hotspotWarmupWait = 18

# Startup delay before script begins (default: 10)
$startupDelay = 10

# Retry attempts for Wi-Fi connection (default: 6)
$maxRetries = 6

# Seconds between retries (default: 8)
$retryInterval = 8
```

---

## 🗑️ Uninstall

To stop the auto-connect behaviour, right-click `remove_task.ps1` → **Run with PowerShell**.

This removes the scheduled task without deleting any files.

---

## 📋 Requirements

- Windows 10 / 11
- iPhone with Shortcuts app
- Bluetooth pairing between laptop and iPhone
- PowerShell (built into Windows)

---

## 📝 Logs

The script logs all activity to `hotspot_log.txt` in the same folder. Check this file if something isn't working.

---

## 🔧 Troubleshooting

| Problem | Fix |
|---|---|
| Shortcut doesn't run on iPhone | Make sure **"Ask Before Running"** is **OFF** in the Shortcut |
| Wi-Fi doesn't connect | Connect to the hotspot manually once first |
| Laptop not in iPhone Bluetooth list | Pair them first (see `IPHONE_SETUP.md`) |
| Script doesn't run at startup | Re-run `setup_task.ps1` as Administrator |

---

## 📄 License

MIT — free to use and modify.
