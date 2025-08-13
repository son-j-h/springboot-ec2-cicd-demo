#!/bin/bash
set -euxo pipefail

# systemd 서비스 파일 복사 (파일이 이미 배포된 후)
if [ -f /home/ec2-user/systemd/demo.service ]; then
  sudo cp /home/ec2-user/systemd/demo.service /etc/systemd/system/demo.service
  sudo systemctl daemon-reload
  echo "[start_app] systemd service file copied and daemon reloaded"
else
  echo "[start_app] Warning: /home/ec2-user/systemd/demo.service not found"
  ls -la /home/ec2-user/systemd || echo "systemd directory does not exist"
fi

sudo systemctl enable demo.service
sudo systemctl restart demo.service
sleep 2
sudo systemctl status demo.service --no-pager || true
