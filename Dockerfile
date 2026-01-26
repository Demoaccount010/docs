FROM debian:bullseye

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x720
ENV VNC_PORT=5901
ENV VNC_PASSWORD=admin123

# 1. Install Dependencies
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
    net-tools \
    procps \
    # Specs Look
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

# 2. Fix noVNC paths & Set Default Page
# Ye line 'vnc.html' ko 'index.html' bana degi taaki direct open ho
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# 3. Setup Directories
RUN mkdir -p /root/.vnc

# 4. Copy Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 5. Start
CMD ["/entrypoint.sh"]
