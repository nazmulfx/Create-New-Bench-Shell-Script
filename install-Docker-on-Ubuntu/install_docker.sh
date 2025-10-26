#!/bin/bash
# ============================================================
# Docker + Docker Compose Installation Script for Ubuntu
# Works on Ubuntu 20.04 / 22.04 / 24.04
# Author: Nazmul Hossain 
# ============================================================

set -e

echo "🚀 Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "🧹 Removing old Docker versions (if any)..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

echo "📦 Installing required dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

echo "🔐 Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "🧱 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "📦 Installing Docker Engine, CLI, Buildx, Compose Plugin..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🧍‍♂️ Adding current user to the docker group..."
sudo usermod -aG docker $USER

echo "⚙️ Enabling Docker to start on boot..."
sudo systemctl enable docker

echo "✅ Checking Docker version..."
docker --version || echo "Please log out and log back in to use Docker without sudo."

echo "✅ Checking Docker Compose version..."
docker compose version || echo "Please log out and log back in to use Docker Compose."

echo "🎉 Docker & Docker Compose installation completed successfully!"
echo "ℹ️ Please log out and log back in (or run 'newgrp docker') to apply user group changes."
