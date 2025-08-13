#!/bin/bash
set -euxo pipefail
sudo systemctl enable demo.service
sudo systemctl restart demo.service
sleep 2
sudo systemctl status demo.service --no-pager || true
