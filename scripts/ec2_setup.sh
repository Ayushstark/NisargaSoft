#!/bin/bash
# One-shot setup for a fresh AWS EC2 t2.micro (Ubuntu 22.04)
# Run: bash ec2_setup.sh
set -e

echo "==> [1/6] System update"
sudo apt-get update -qq && sudo apt-get upgrade -y -qq

echo "==> [2/6] Install Docker"
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

echo "==> [3/6] Install Docker Compose plugin"
sudo apt-get install -y -qq docker-compose-plugin

echo "==> [4/6] Setup 2GB swap (critical for Playwright on 1GB RAM)"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# Tune swappiness — only use swap when really needed
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "==> [5/6] Open firewall ports (Ubuntu ufw)"
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

echo "==> [6/6] Clone repo"
git clone https://github.com/Ayushstark/NisargaSoft.git ~/app

echo ""
echo "✅ Setup complete. Next steps:"
echo "   1. Upload your .env:  scp -i key.pem .env ubuntu@<IP>:~/app/.env"
echo "   2. cd ~/app && docker compose -f docker-compose.prod.yml up -d --build"
echo ""
echo "⚠️  Log out and back in for docker group to take effect, or run: newgrp docker"
