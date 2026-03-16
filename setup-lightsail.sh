#!/bin/bash
# First-time setup script for Lightsail instance
# Run this once on the Lightsail machine: bash setup.sh

set -e

echo "=== Installing Docker ==="
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "=== Installing Docker Compose ==="
DOCKER_COMPOSE_VERSION="v2.27.0"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Also install as docker plugin
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "=== Installing Git ==="
sudo yum install -y git

echo "=== Creating app directory ==="
mkdir -p /home/ec2-user/app

echo "=== Setup complete ==="
echo "IMPORTANT: Log out and log back in for docker group to take effect."
echo "Then create /home/ec2-user/app/.env with your environment variables."
docker --version
docker compose version
