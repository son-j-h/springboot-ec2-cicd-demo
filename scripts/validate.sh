#!/usr/bin/env bash
set -euxo pipefail
curl -fsS http://localhost:8080/actuator/health | grep -q '"status":"UP"'
curl -fsS http://localhost:8080/api/build | grep -q 'commit'
