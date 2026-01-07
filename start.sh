#!/bin/bash

echo "[+] Starting Ubuntu VPS..."

# DBus
mkdir -p /var/run/dbus
dbus-daemon --system --fork || true

# X11 temp directory
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Ensure VNC permissions
chmod 600 /root/.vnc/passwd
chmod 755 /root/.vnc/xstartup

# Kill old VNC session if exists
vncserver -kill :2000 >/dev/null 2>&1 || true

# Start VNC
vncserver :2000 -geometry 1360x768 -depth 24

# Start noVNC
cd /noVNC-1.2.0
./utils/launch.sh --vnc localhost:7900 --listen 8900
