#!/bin/bash

echo "------------------------------------------------"
echo "Starting Render VPS..."
echo "------------------------------------------------"

# 1. Clean up old locks
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. Set VNC Password
mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# 3. Start VNC Server
echo "Starting VNC Server on :1..."
vncserver :1 -geometry $RESOLUTION -depth 24 -passwd /root/.vnc/passwd &

# 4. Start XFCE
echo "Starting XFCE Desktop..."
export DISPLAY=:1
dbus-launch startxfce4 &

# 5. Start noVNC
if [ -z "$PORT" ]; then
    PORT=8080
fi

echo "Starting noVNC on port $PORT..."
/usr/lib/python3/dist-packages/websockify/websocketproxy.py --web /usr/share/novnc/ $PORT localhost:5901 &

# 6. Fixes
echo "export MOZ_FAKE_NO_SANDBOX=1" >> /root/.bashrc
echo "export NO_SANDBOX=1" >> /root/.bashrc

# 7. Show Specs (Ab Neofetch chalega)
echo "------------------------------------------------"
neofetch
echo "------------------------------------------------"

# 8. THE FOREVER LOOP
echo "Container is running. Access via Render URL."
tail -f /dev/null
