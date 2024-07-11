#!/bin/bash

# Check if the script is run as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit
fi

# Install Docker
echo "Installing Docker..."

# Remove old versions if any
apt-get remove docker docker-engine docker.io containerd runc

# Install dependencies
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install Docker engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Docker installed successfully."

# Install Docker Compose
echo "Installing Docker Compose..."

# Download the latest version of Docker Compose
sudo curl -sSL https://github.com/docker/compose/releases/download/2.18.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
chmod +x /usr/local/bin/docker-compose

echo "Docker Compose installed successfully."

# Display Docker and Docker Compose versions
docker --version
docker-compose --version

echo "Script completed."
