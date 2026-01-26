# Base Image - Using Debian Sid (Unstable) for newer packages or Bullseye for stability. 
# We use stable here for best bot performance.
FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1280x720
ENV VNC_PASSWORD=admin123

# 1. Optimize Repos & Install Essentials (One single RUN layer to save space)
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    wget \
    curl \
    git \
    vim \
    xz-utils \
    dbus-x11 \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    python3 \
    python3-pip \
    nodejs \
    npm \
    # Heavy Bot Tools
    aria2 \
    ffmpeg \
    p7zip-full \
    htop \
    # Browser
    firefox-esr \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install noVNC (The Web Viewer)
RUN mkdir -p /opt/novnc \
    && wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz -C /opt/novnc --strip-components=1 \
    && ln -s /opt/novnc/utils/launch.sh /opt/novnc/launch.sh \
    && mkdir -p /opt/novnc/utils/websockify \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar xz -C /opt/novnc/utils/websockify --strip-components=1

# 3. Setup Environment for Root (Allows Firefox to run as root)
ENV HOME=/root
RUN mkdir -p $HOME/.vnc
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 4. Port Exposure
EXPOSE 8080

# 5. Start Command
CMD ["/start.sh"]
