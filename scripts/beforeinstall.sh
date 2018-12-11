#!/bin/bash

# configure node.js repo
sudo apt-get install curl python-software-properties
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# install node.js
apt install nodejs -y
sudo npm install -g pm2

# create systemd service
cat > /etc/systemd/system/nodejs.service <<'EOF'
[Unit]
Description=Node.js App
After=network.target
[Service]
User=nobody
WorkingDirectory=/var/www/nodejs
ExecStart=/usr/bin/npm run start:dev
Restart=always
RestartSec=500ms
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF



# reload systemd services
systemctl daemon-reload
systemctl enable nodejs.service

# remove old directory
rm -rf /var/www/nodejs

# create directory node.js app
mkdir -p /var/www/nodejs 
