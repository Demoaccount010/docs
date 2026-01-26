FROM debian:bullseye

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x720
ENV VNC_PORT=5901
ENV VNC_PASSWORD=admin123

# 1. Install Sabkuch (Ab isme Neofetch bhi daal diya hai)
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
    # Specs dikhane ke liye safe tool
    neofetch \
    # Bot Tools
    python3 \
    python3-pip \
    aria2 \
    ffmpeg \
    p7zip-full \
    htop \
    chromium \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Setup noVNC
RUN ln -s /usr/share/novnc/utils/launch.sh /usr/share/novnc/launch.sh && \
    ln -s /usr/lib/python3/dist-packages/websockify /usr/share/novnc/utils/websockify

# 3. Copy Script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 4. Fix Permissions
RUN mkdir -p /root/.vnc

# 5. Start
CMD ["/entrypoint.sh"]
