FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=8900

# Enable i386 (for Wine)
RUN dpkg --add-architecture i386

# Update & install core packages
RUN apt update && apt install -y \
    sudo \
    dbus-x11 \
    curl \
    wget \
    git \
    unzip \
    xz-utils \
    net-tools \
    software-properties-common \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    tightvncserver \
    firefox \
    mate-system-monitor \
    gnome-system-monitor \
    fonts-zenhei \
    wine64 \
    wine32 \
    qemu-kvm \
    supervisor \
    && apt clean && rm -rf /var/lib/apt/lists/*

# noVNC install
WORKDIR /opt
RUN git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify noVNC/utils/websockify

# Create user (non-root = stable)
RUN useradd -m -s /bin/bash admin && \
    echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER admin
WORKDIR /home/admin

# VNC setup
RUN mkdir -p ~/.vnc && \
    echo "admin123@a" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# XFCE startup
RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec dbus-launch --exit-with-session startxfce4 &' \
> ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup

# Supervisor config
USER root
RUN mkdir -p /etc/supervisor/conf.d

RUN echo "[supervisord]\n\
nodaemon=true\n\
\n\
[program:vnc]\n\
command=/usr/bin/vncserver :1 -geometry 1366x768 -depth 24\n\
user=admin\n\
autorestart=true\n\
\n\
[program:novnc]\n\
command=/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 8900\n\
user=admin\n\
autorestart=true" \
> /etc/supervisor/conf.d/vps.conf

EXPOSE 8900

CMD ["/usr/bin/supervisord"]
