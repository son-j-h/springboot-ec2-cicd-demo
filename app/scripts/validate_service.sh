#!/bin/bash
set -e

echo "=== Validating Service ==="
echo "Starting service validation at $(date)"

# Wait for the service to be fully initialized
echo "Waiting for service initialization..."
sleep 20

# Check if the application process is running
echo "Checking application process..."
if [ -f "/home/ec2-user/app/application.pid" ]; then
    PID=$(cat /home/ec2-user/app/application.pid)
    if kill -0 $PID 2>/dev/null; then
        echo "✅ Application process is running (PID: $PID)"
    else
        echo "❌ Application process is not running"
        exit 1
    fi
else
    echo "❌ PID file not found"
    exit 1
fi

# Test HTTP connectivity
echo "Testing HTTP connectivity..."
MAX_ATTEMPTS=15
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Validation attempt $ATTEMPT/$MAX_ATTEMPTS"

    # Try to connect to the health endpoint
    if curl -f -s --connect-timeout 10 http://localhost/health > /dev/null 2>&1; then
        echo "✅ Health endpoint validation successful!"
        curl -s http://localhost/health | head -5
        break
    fi

    # Try to connect to the root endpoint
    if curl -f -s --connect-timeout 10 http://localhost/ > /dev/null 2>&1; then
        echo "✅ Root endpoint validation successful!"
        echo "Application is accessible at http://localhost/"
        break
    fi

    # Check if we're on the last attempt
    if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
        echo "❌ Service validation failed after $MAX_ATTEMPTS attempts!"

        # Show debugging information
        echo "=== Debugging Information ==="
        echo "Process status:"
        ps aux | grep shopping-mall.jar || echo "No process found"

        echo "Port status:"
        sudo netstat -tulpn | grep :80 || echo "Port 80 not listening"

        echo "Application logs (last 20 lines):"
        tail -20 /home/ec2-user/logs/application.log 2>/dev/null || echo "No log file found"

        echo "Application output (last 20 lines):"
        tail -20 /home/ec2-user/logs/application.out 2>/dev/null || echo "No output file found"

        exit 1
    fi

    echo "Service not ready yet, waiting 10 seconds..."
    sleep 10
    ATTEMPT=$((ATTEMPT + 1))
done

echo "=== Service Validation Completed ==="
echo "Validation completed at $(date)"
