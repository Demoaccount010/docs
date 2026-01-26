#!/bin/bash

# Set default password if not provided in Render Environment Variables
VNC_PASSWORD=${VNC_PASSWORD:-render123}

# Create VNC Password file
mkdir -p $HOME/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Fix Chrome Sandbox issues for Docker
echo "export NO_SANDBOX=1" >> $HOME/.bashrc

# Ensure the Render PORT variable is set, default to 10000 if testing locally
if [ -z "$PORT" ]; then
    export PORT=10000
fi

echo "------------------------------------------------"
echo "Starting VPS..."
echo "User: render"
echo "Resolution: $RESOLUTION"
echo "Web Port: $PORT"
echo "------------------------------------------------"

# Start Supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
