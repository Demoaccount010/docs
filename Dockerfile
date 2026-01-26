FROM debian:bullseye

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x720
ENV VNC_PORT=5901
ENV VNC_PASSWORD=admin123

# 1. Install Sabkuch (GUI, VNC, Bots Tools)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    sudo \
    curl \
    wget \
    git \
    nano \
    # Bot Tools
    python3 \
    python3-pip \
    aria2 \
    ffmpeg \
    p7zip-full \
    htop \
    chromium \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Setup noVNC (Manual Linking for stability)
RUN ln -s /usr/share/novnc/utils/launch.sh /usr/share/novnc/launch.sh && \
    ln -s /usr/lib/python3/dist-packages/websockify /usr/share/novnc/utils/websockify

# 3. Install Fastfetch (For showing Fake High Specs)
RUN wget https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb && \
    dpkg -i fastfetch-linux-amd64.deb && \
    rm fastfetch-linux-amd64.deb

# 4. Copy Script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 5. Fix Permissions
RUN mkdir -p /root/.vnc

# 6. Start
CMD ["/entrypoint.sh"]
