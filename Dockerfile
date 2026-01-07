FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN dpkg --add-architecture i386

# Update
RUN apt update

# Install REQUIRED + SAFE packages only
RUN apt install -y \
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
    mate-system-monitor \
    gnome-system-monitor \
    fonts-wqy-zenhei \
    wine64 \
    wine32:i386 \
    supervisor \
    --no-install-recommends \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# noVNC
WORKDIR /opt
RUN git clone https://github.com/novnc/noVNC.git \
 && git clone https://github.com/novnc/websockify noVNC/utils/websockify

# User
RUN useradd -m admin && echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER admin
WORKDIR /home/admin

# VNC setup
RUN mkdir -p ~/.vnc && \
    echo "admin123@a" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec dbus-launch --exit-with-session startxfce4 &' \
> ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup

# Supervisor
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
