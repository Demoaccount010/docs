FROM ubuntu:22.04

# 1. Setup Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NO_VNC_PORT=10000
ENV RESOLUTION=1280x720
ENV HOME=/home/render
ENV USER=render

# 2. Install Core System, GUI (XFCE), and VNC
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    supervisor \
    xterm \
    dbus-x11 \
    sudo \
    curl \
    wget \
    git \
    nano \
    # High Performance Tools for Bots
    python3 \
    python3-pip \
    nodejs \
    npm \
    aria2 \
    ffmpeg \
    p7zip-full \
    htop \
    chromium-browser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Create User 'render' and give sudo access
RUN useradd -m -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 4. Setup VNC and Supervisor Directories
RUN mkdir -p /usr/share/novnc/utils/websockify && \
    ln -s /usr/lib/python3/dist-packages/websockify /usr/share/novnc/utils/websockify && \
    mkdir -p $HOME/.vnc && \
    mkdir -p /var/log/supervisor

# 5. Copy Configuration Files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

# 6. Set Permissions
RUN chmod +x /entrypoint.sh && \
    chown -R $USER:$USER $HOME

# 7. Switch to User
USER $USER
WORKDIR $HOME

# 8. Start
ENTRYPOINT ["/entrypoint.sh"]
