#!/bin/bash
# Run this on your Oracle Cloud VM after SSH-ing in
# ssh -i your-key.pem ubuntu@YOUR_VM_IP

set -e

echo "==> Updating system"
sudo apt-get update && sudo apt-get upgrade -y

echo "==> Installing Docker"
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

echo "==> Installing Docker Compose"
sudo apt-get install -y docker-compose-plugin

echo "==> Opening firewall ports"
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
sudo apt-get install -y iptables-persistent
sudo netfilter-persistent save

echo "==> Cloning repo"
sudo apt-get install -y git
git clone https://github.com/Ayushstark/NisargaSoft.git
cd NisargaSoft

echo "==> Done. Now:"
echo "  1. Copy your .env file: scp -i key.pem .env ubuntu@IP:~/NisargaSoft/.env"
echo "  2. Run: cd NisargaSoft && docker compose up -d"
