#!/bin/bash

echo "------------------------------------------------"
echo "Starting Render VPS (Stable Mode)..."
echo "------------------------------------------------"

# 1. Clean up old locks
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. Set VNC Password
mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# 3. Start VNC Server (TigerVNC)
echo "Starting VNC Server on :1..."
# 'localhost' flag zaroori hai taaki bahar se koi direct hack na kare
vncserver :1 -geometry $RESOLUTION -depth 24 -localhost -passwd /root/.vnc/passwd &

# Wait for VNC to fully start
sleep 5

# 4. Start XFCE Desktop
echo "Starting XFCE Desktop..."
export DISPLAY=:1
dbus-launch startxfce4 &

# 5. Start noVNC (Web Server)
if [ -z "$PORT" ]; then
    PORT=10000
fi

echo "Starting noVNC on port $PORT..."
echo "Access URL: https://your-app.onrender.com (No need for /vnc.html)"

# Hum seedha 'websockify' executable use karenge (Python script path ka jhanjhat khatam)
websockify --web=/usr/share/novnc/ 0.0.0.0:$PORT localhost:5901 &

# 6. Browser Sandbox Fix
echo "export MOZ_FAKE_NO_SANDBOX=1" >> /root/.bashrc
echo "export NO_SANDBOX=1" >> /root/.bashrc

# 7. Show Specs
echo "------------------------------------------------"
neofetch
echo "------------------------------------------------"

# 8. Keep Alive
tail -f /dev/null
