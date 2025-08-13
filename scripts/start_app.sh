#!/bin/bash
set -euxo pipefail

# systemd 서비스 파일 복사 (파일이 이미 배포된 후이므로 안전)
if [ -f /home/ec2-user/systemd/demo.service ]; then
  sudo cp /home/ec2-user/systemd/demo.service /etc/systemd/system/demo.service
  sudo systemctl daemon-reload
fi

sudo systemctl enable demo.service
sudo systemctl restart demo.service
sleep 2
sudo systemctl status demo.service --no-pager || true
