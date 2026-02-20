#!/bin/bash
#Install Docker in Amazon Ubuntu
set -e  # Exit on any error

echo "Updating system packages..."
sudo apt update -y

echo "Installing dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# CRITICAL: Remove ALL old/duplicate Docker repository files BEFORE adding new ones
echo "Removing old Docker repository configurations..."
# Find and remove all Docker source list files
sudo find /etc/apt/sources.list.d/ -type f \( -name "*docker*" -o -name "*archive_uri*download*docker*" \) -delete
# Double check by explicitly removing these pattern files
sudo rm -f /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-*.list 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/docker.list 2>/dev/null || true

echo "Creating keyrings directory..."
sudo mkdir -p /etc/apt/keyrings

echo "Downloading Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting GPG key permissions..."
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating repositories (warnings should be gone now)..."
sudo apt update -y

echo "Checking Docker availability..."
sudo apt-cache policy docker-ce

echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Checking Docker status..."
sudo systemctl status docker

echo "Setting Docker socket permissions..."
sudo chmod 666 /var/run/docker.sock

echo "Docker installation completed successfully!"
docker --version
