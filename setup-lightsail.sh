#!/bin/bash
# First-time setup script for Lightsail instance (Amazon Linux 2)
# Run this once on the Lightsail machine: bash setup-lightsail.sh

set -e

echo "=== Installing Docker ==="
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "=== Installing Docker CLI plugins ==="
sudo mkdir -p /usr/local/lib/docker/cli-plugins

# Install latest Docker Compose plugin
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Installing Docker Compose ${COMPOSE_VERSION}..."
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Install latest Docker Buildx plugin
BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Installing Docker Buildx ${BUILDX_VERSION}..."
sudo curl -L "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" \
  -o /usr/local/lib/docker/cli-plugins/docker-buildx
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

echo "=== Installing Git ==="
sudo yum install -y git

echo "=== Creating app directory ==="
mkdir -p /home/ec2-user/app

echo "=== Setup complete ==="
echo "IMPORTANT: Log out and log back in for docker group to take effect."
echo "Then create /home/ec2-user/app/.env with your environment variables."
docker --version
docker compose version
docker buildx version
