# iPhone Shortcuts Setup Guide

## What this does
When your laptop starts and Bluetooth reconnects to your iPhone,
your iPhone will automatically turn on the Personal Hotspot.

---

## Step 1 — Pair Bluetooth (one-time)
1. On your iPhone: Settings > Bluetooth > make sure it is ON
2. On your laptop: Start > Settings > Bluetooth & devices > Add device
3. Select your iPhone and pair them
4. After pairing, your laptop will auto-reconnect to your iPhone Bluetooth every startup

---

## Step 2 — Create iPhone Shortcut Automation

1. Open the **Shortcuts** app on your iPhone
2. Tap the **Automation** tab (bottom middle)
3. Tap **+** (top right) to create new automation
4. Scroll down and tap **Bluetooth**
5. Tap **Choose** next to "Device" and select your **laptop** from the list
6. Make sure **Connects** is selected (not Disconnects)
7. Tap **Next**
8. Tap **New Blank Automation**
9. Tap **Add Action**, search for **"Personal Hotspot"**
10. Select **Set Personal Hotspot**
11. Make sure it says **"Turn Personal Hotspot On"** (tap to toggle if needed)
12. Tap **Next**
13. IMPORTANT: Turn OFF **"Ask Before Running"** toggle
14. Tap **Done**

---

## Step 3 — Test it

1. Turn OFF your iPhone hotspot manually
2. Disconnect Bluetooth from your laptop (turn off and on again)
3. Watch your iPhone — the hotspot should turn on automatically within a few seconds

---

## Full Automatic Flow (after setup)

```
Laptop starts
    |
    v
Windows reconnects Bluetooth to iPhone automatically
    |
    v
iPhone Shortcuts detects Bluetooth connection
    |
    v
Shortcut runs: Personal Hotspot turns ON
    |
    v
connect_hotspot.ps1 waits 18 seconds, then connects WiFi
    |
    v
You are online!
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Shortcut does not run | Make sure "Ask Before Running" is OFF |
| Laptop not in Bluetooth device list | Pair them first (Step 1) |
| WiFi does not connect | Make sure you connected to hotspot manually at least once |
| Hotspot turns off too fast | iPhone keeps hotspot on as long as a device is connected |
