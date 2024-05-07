#!/bin/bash -v
echo "=== Ubuntu VM Setup with Docker environment ==="

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: please run the script with sudo"
    exit 1
fi

# Check if system is Ubuntu
if [ ! -x "$(command -v apt-get)" ]; then
    echo "Error: this script is not compatible with your system"
    exit 1
fi

# System update
echo "*** System update ***"
apt update && apt upgrade -y

# Install Requirements
echo "*** Install Requirements ***"
apt install ca-certificates curl nfs-common git -y

# Docker
if [ ! -x "$(command -v docker)" ]; then
  echo "*** Install Docker ***"
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update -y
  apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  usermod -aG docker $SUDO_USER
fi

# Neofetch
if [ ! -x "$(command -v neofetch)" ]; then
  echo "*** Install Neofetch ***"
  apt install neofetch -y
fi

# ShinSakanami/docker repo
if [ ! -x "/home/$SUDO_USER/docker" ]; then
  echo "*** Clone ShinSakanami/docker repo ***"
  cd /home/$SUDO_USER
  git clone https://github.com/ShinSakanami/docker/
fi

# TrueNAS mounts
if [ ! -x "/home/$SUDO_USER/truenas" ]; then
  echo "*** Add TrueNAS folders ***"
  cd /home/$SUDO_USER
  mkdir truenas
  mkdir truenas/appdata
  mkdir truenas/cache
  mkdir truenas/backups
  mkdir truenas/share
  # Add cloud folder yes/no
  # Add media folder yes/no
  # Add downloads folder yes/no
fi

echo "=== Setup finished ==="
exit 0