#!/bin/bash
set -euxo pipefail

echo "[before_install] PWD=$(pwd)"
ls -la || true

sudo mkdir -p /home/ec2-user/app
sudo chown ec2-user:ec2-user /home/ec2-user/app

if ! command -v java >/dev/null 2>&1; then
  sudo yum -y install java-17-amazon-corretto-headless || sudo dnf -y install java-17-amazon-corretto-headless || true
fi

if [ -f systemd/demo.service ]; then
  sudo cp systemd/demo.service /etc/systemd/system/demo.service
  sudo systemctl daemon-reload
else
  echo "[before_install] systemd/demo.service not found in revision"
  ls -la systemd || true
  exit 1
fi
