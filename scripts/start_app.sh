#!/usr/bin/env bash
set -euxo pipefail
# Copy app jar from deployed location to service working directory
sudo cp /home/ec2-user/app/app.jar /opt/demo/app.jar
# Start service
sudo systemctl enable demo.service
sudo systemctl start demo.service
