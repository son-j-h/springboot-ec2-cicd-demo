#!/usr/bin/env bash
set -euxo pipefail
sudo mkdir -p /opt/demo
sudo chown ec2-user:ec2-user /opt/demo || true
sudo cp systemd/demo.service /etc/systemd/system/demo.service
sudo systemctl daemon-reload
