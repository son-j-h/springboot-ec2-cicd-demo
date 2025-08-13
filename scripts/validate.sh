#!/bin/bash
set -euo pipefail

echo "[validate] Checking if service is running"

# 서비스가 실행 중인지만 확인
if sudo systemctl is-active --quiet demo.service; then
  echo "[validate] demo.service is active"
  exit 0
else
  echo "[validate] demo.service is not active"
  exit 1
fi
