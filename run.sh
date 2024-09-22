#!/bin/bash

# Set service name and path to Python script
SERVICE_NAME=your_python_service
SCRIPT_PATH=/path/to/your/python/script.py

# Create service file
cat <<EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=Your Python Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c "sudo -u your_user $SCRIPT_PATH"  # Run as a specific user (optional)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd configuration
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service

# Check service status
sudo systemctl status $SERVICE_NAME.service