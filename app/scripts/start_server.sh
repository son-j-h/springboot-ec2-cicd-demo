#!/bin/bash
set -e

echo "=== Starting Spring Boot Application ==="
echo "Starting application at $(date)"

# Navigate to application directory
echo "Changing to application directory..."
cd /home/ec2-user/app

# Check if JAR file exists
if [ ! -f "shopping-mall.jar" ]; then
    echo "ERROR: shopping-mall.jar not found in /home/ec2-user/app"
    ls -la /home/ec2-user/app/
    exit 1
fi

echo "Found JAR file:"
ls -lh shopping-mall.jar

# Set Java environment
echo "Setting up Java environment..."
export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java
echo "Using Java version:"
$JAVA_HOME/bin/java -version

# Set application configuration
export SPRING_PROFILES_ACTIVE=prod
export SERVER_PORT=80

# Create logs directory if it doesn't exist
mkdir -p /home/ec2-user/logs

echo "Starting Spring Boot application..."
nohup $JAVA_HOME/bin/java \
    -Xms512m \
    -Xmx1024m \
    -Dspring.profiles.active=prod \
    -Dserver.port=80 \
    -Dlogging.file.name=/home/ec2-user/logs/application.log \
    -jar shopping-mall.jar \
    > /home/ec2-user/logs/application.out 2>&1 &

# Get the PID
PID=$!
echo "Application started with PID: $PID"

# Save PID for later use
echo $PID > /home/ec2-user/app/application.pid

# Wait a moment for startup
echo "Waiting for application startup..."
sleep 15

# Verify the application is running
if kill -0 $PID 2>/dev/null; then
    echo "✅ Application is running successfully!"
    echo "PID: $PID"
    echo "Log file: /home/ec2-user/logs/application.log"
    echo "Output file: /home/ec2-user/logs/application.out"
else
    echo "❌ Application failed to start!"
    echo "Checking logs..."
    if [ -f "/home/ec2-user/logs/application.out" ]; then
        echo "=== Application Output ==="
        tail -20 /home/ec2-user/logs/application.out
    fi
    exit 1
fi

echo "=== Application Start Completed ==="
echo "Start completed at $(date)"
