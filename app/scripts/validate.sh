#!/bin/bash
set -euo pipefail

URL="http://localhost:8080/health"
echo "[validate] probing ${URL}"

for i in {1..30}; do
  if curl -fsS "${URL}" >/dev/null 2>&1; then
    echo "[validate] app is up"
    exit 0
  fi
  sleep 2
done

echo "[validate] app did not respond in time"
exit 1
