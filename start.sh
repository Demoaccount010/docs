#!/bin/bash

# 1. Set VNC Password
echo "Setting VNC Password..."
mkdir -p $HOME/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# 2. Start VNC Server (The Desktop)
echo "Starting VNC Server..."
# We kill any old locks just in case
rm -rf /tmp/.X0-lock /tmp/.X11-unix/X0
vncserver :0 -geometry $RESOLUTION -depth 24

# 3. Enable Audio/Sandbox Fix for Firefox
export MOZ_FAKE_NO_SANDBOX=1

# 4. Start noVNC (The Web Interface)
echo "Starting noVNC on port 8080..."
/opt/novnc/launch.sh --vnc localhost:5900 --listen 8080 &

# 5. Start Desktop Environment
echo "Starting XFCE4..."
DISPLAY=:0 startxfce4 &

# 6. Keep Container Alive (For Heavy Bots)
echo "Container Started. Ready for heavy tasks."
echo "Use 'aria2c -x 16 URL' for fast downloads."
tail -f /dev/null
