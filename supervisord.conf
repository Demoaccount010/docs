[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/log/supervisor/supervisord.pid

[program:xvnc]
command=/usr/bin/Xtightvnc :1 -geometry %(ENV_RESOLUTION)s -depth 24 -rfbauth /home/render/.vnc/passwd
autorestart=true
user=render
priority=1

[program:xfce4]
command=/usr/bin/startxfce4
environment=DISPLAY=":1"
autorestart=true
user=render
priority=2

[program:novnc]
# Render passes the port in the $PORT variable. We map it here.
command=/usr/share/novnc/utils/launch.sh --listen %(ENV_PORT)s --vnc localhost:5901
autorestart=true
user=render
priority=3
