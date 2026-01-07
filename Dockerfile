FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Enable i386 for wine
RUN dpkg --add-architecture i386

# Update system
RUN apt update

# Install packages (same as tera Debian intent)
RUN apt install -y \
    wine \
    wine32 \
    wine64 \
    xz-utils \
    dbus-x11 \
    curl \
    firefox \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    wget \
    fonts-wqy-zenhei \
    --no-install-recommends \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Download noVNC
WORKDIR /
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz \
 && tar -xvf v1.2.0.tar.gz \
 && rm v1.2.0.tar.gz

# VNC setup
RUN mkdir -p /root/.vnc
RUN echo 'admin123@a' | vncpasswd -f > /root/.vnc/passwd
RUN echo '#!/bin/sh\n/bin/env MOZ_FAKE_NO_SANDBOX=1 dbus-launch xfce4-session &' > /root/.vnc/xstartup
RUN chmod 600 /root/.vnc/passwd
RUN chmod 755 /root/.vnc/xstartup

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8900

CMD ["/start.sh"]
