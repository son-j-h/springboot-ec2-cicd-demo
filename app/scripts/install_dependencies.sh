#!/bin/bash
set -e

echo "=== Installing Dependencies ==="
echo "Starting dependency installation at $(date)"

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Java 17 if not present
echo "Checking Java installation..."
if ! java -version 2>&1 | grep -q "17"; then
    echo "Installing Amazon Corretto 17..."
    sudo yum install -y java-17-amazon-corretto
else
    echo "Java 17 already installed"
fi

# Verify Java installation
echo "Java version:"
java -version

# Create application directories
echo "Creating application directories..."
sudo mkdir -p /home/ec2-user/app
sudo mkdir -p /home/ec2-user/logs

# Set proper permissions
echo "Setting directory permissions..."
sudo chown -R ec2-user:ec2-user /home/ec2-user/app
sudo chown -R ec2-user:ec2-user /home/ec2-user/logs

# Install additional tools if needed
echo "Installing additional tools..."
sudo yum install -y wget curl

echo "=== Dependencies Installation Completed ==="
echo "Installation completed at $(date)"
