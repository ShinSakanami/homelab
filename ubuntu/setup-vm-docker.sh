#!/bin/bash -v
echo "=== Ubuntu VM Setup with Docker environment ==="

# Check if system is Ubuntu
if [ ! -x "$(command -v apt-get)" ]; then
    echo "Error: this script is not compatible with your system"
    exit 1
fi

# System update
echo "*** System update ***"
sudo apt update && apt upgrade -y

# Install Requirements
echo "*** Install Requirements ***"
sudo apt install ca-certificates curl nfs-common git -y

# Docker
if [ ! -x "$(command -v docker)" ]; then
  echo "*** Install Docker ***"
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update -y
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo usermod -aG docker $USER
fi

# Neofetch
if [ ! -x "$(command -v neofetch)" ]; then
  echo "*** Install Fastfetch ***"
  sudo apt install fastfetch -y
fi

# ShinSakanami/docker repo
if [ ! -x "/home/$SUSER/docker" ]; then
  echo "*** Clone ShinSakanami/docker repo ***"
  cd /home/$USER
  git clone https://github.com/ShinSakanami/docker/
fi

echo "=== Setup finished ==="
exit 0