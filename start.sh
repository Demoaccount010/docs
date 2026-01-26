#!/bin/bash
# Is file ka kaam sirf initial password set karna hai, baaki kaam Supervisor karega
mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Remove old locks
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
