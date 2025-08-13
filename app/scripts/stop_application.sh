#!/bin/bash
set -e

echo "=== Stopping Application ==="
echo "Stopping application at $(date)"

# Find Spring Boot application process
echo "Looking for running Spring Boot application..."
PID=$(pgrep -f "shopping-mall.jar" || echo "")

if [ -n "$PID" ]; then
    echo "Found running application with PID: $PID"
    echo "Sending SIGTERM signal..."
    kill -15 $PID

    # Wait for graceful shutdown (up to 30 seconds)
    for i in {1..30}; do
        if ! kill -0 $PID 2>/dev/null; then
            echo "Application stopped gracefully after $i seconds"
            break
        fi
        echo "Waiting for graceful shutdown... ($i/30)"
        sleep 1
    done

    # Force kill if still running
    if kill -0 $PID 2>/dev/null; then
        echo "Force killing application with PID: $PID"
        kill -9 $PID
        sleep 2
    fi

    echo "Application process stopped"
else
    echo "No running Spring Boot application found"
fi

# Clean up any remaining processes
echo "Cleaning up any remaining Java processes..."
sudo pkill -f "shopping-mall.jar" 2>/dev/null || true

echo "=== Application Stop Completed ==="
echo "Stop completed at $(date)"
