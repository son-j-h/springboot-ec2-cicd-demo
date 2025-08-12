#!/usr/bin/env bash
set -euxo pipefail
# Copy app jar
sudo cp app/build/libs/app.jar /opt/demo/app.jar
# Copy build metadata for UI
sudo cp app/public/build.json /opt/demo/build.json
# Start service
sudo systemctl enable demo.service
sudo systemctl start demo.service
