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
DOCKERCOMPOSECURRENTRELEASENUMBER="$(curl -4 -k --http2 https://github.com/docker/compose/releases | grep -m1 '<a href="/docker/compose/releases/download/' | awk -F/ '{print $6}')"

if [[ ! -f /usr/local/bin/docker-compose ]]; then

    curl -L "https://github.com/docker/compose/releases/download/"$DOCKERCOMPOSECURRENTRELEASENUMBER"/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    docker-compose --version

    echo "Docker Compose installed successfully."
fi
# Make it executable

# Display Docker and Docker Compose versions
docker --version
docker-compose --version

echo "Script completed."
