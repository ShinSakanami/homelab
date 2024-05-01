#!/bin/bash -v
echo "=== Ubuntu VM Setup with Docker environment ==="

# Check if user is root
if [ "$EUID" -ne 0 ]; then
    echo "Error: please run the script as root"
    exit 1
fi

# Check if system is Ubuntu
if ! [ -x "$(command -v apt-get)" ]; then
    echo "Error: this script is not compatible with your system"
    exit 1
fi

# System update
echo "*** System update ***"
apt update && sudo apt upgrade -y

# Install NFS tools
echo "*** Install NFS tools ***"
apt install nfs-common -y

# Install Docker
echo "*** Install Docker ***"
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install docker-ce docker-compose -y
usermod -aG docker $USER

# Clone ShinSakanami/docker repo
echo "*** Clone ShinSakanami/docker repo ***"
apt install git -y
git clone https://github.com/ShinSakanami/docker/

echo "=== Setup finished ==="