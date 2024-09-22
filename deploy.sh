#!/bin/bash

echo 'Starting deployment script...'

PI_USER=samer
PI_HOST=192.168.0.25
PI_PATH=/home/samer/cctv
SERVICE_NAME=cctv.service
FILES='main.py requirements.txt'

echo 'Ensuring the target directory exists on Raspberry Pi...'
ssh $PI_USER@$PI_HOST "[ -d $PI_PATH ] || mkdir -p $PI_PATH"

echo 'Transferring files to Raspberry Pi...'
scp $FILES $PI_USER@$PI_HOST:$PI_PATH

echo 'Installing required packages on Raspberry Pi...'
ssh $PI_USER@$PI_HOST << EOF
sudo apt update
sudo apt install -y python3 python3-pip python3-venv
cd $PI_PATH
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
EOF

echo 'Creating and enabling the systemd service...'
ssh $PI_USER@$PI_HOST << EOF
cat <<EOL | sudo tee /etc/systemd/system/$SERVICE_NAME
[Unit]
Description=CCTV Service
After=network.target

[Service]
Type=simple
User=$PI_USER
WorkingDirectory=$PI_PATH
ExecStart=$PI_PATH/venv/bin/python $PI_PATH/main.py
Restart=always

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME
EOF

echo 'Deployment complete. Checking service status...'
ssh $PI_USER@$PI_HOST "sudo systemctl status $SERVICE_NAME"
