#!/bin/bash

echo "------------------------------------------------"
echo "Starting Render VPS..."
echo "------------------------------------------------"

# 1. Clean up old locks (Agar container restart hua ho)
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. Set VNC Password
mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# 3. Start VNC Server (Desktop)
echo "Starting VNC Server on :1..."
vncserver :1 -geometry $RESOLUTION -depth 24 -passwd /root/.vnc/passwd &

# 4. Start XFCE (GUI)
echo "Starting XFCE Desktop..."
export DISPLAY=:1
dbus-launch startxfce4 &

# 5. Start noVNC (Web Server) - IMPORTANT FOR RENDER
# Render automatic PORT variable deta hai (usually 10000). Hum usi ko use karenge.
if [ -z "$PORT" ]; then
    PORT=8080
fi

echo "Starting noVNC on port $PORT..."
# Hum direct websockify use kar rahe hain taaki connection fail na ho
/usr/lib/python3/dist-packages/websockify/websocketproxy.py --web /usr/share/novnc/ $PORT localhost:5901 &

# 6. Chromium Crash Fix
echo "export MOZ_FAKE_NO_SANDBOX=1" >> /root/.bashrc
echo "export NO_SANDBOX=1" >> /root/.bashrc

# 7. THE FOREVER LOOP (Ye line container ko band hone se rokegi)
echo "Container is running. Access via Render URL."
tail -f /dev/null
