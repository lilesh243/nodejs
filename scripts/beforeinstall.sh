#!/bin/bash

# configure node.js repo
sudo apt-get install curl python-software-properties
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# install node.js
sudo apt install nodejs -y
#sudo npm install -g pm2
sudo apt-get install npm -y

# create systemd service
:
# create springboot service
cat > /etc/init/nodejs.conf <<'EOF'
description Node.js App
  start on runlevel [2345]
  stop on runlevel [!2345]
  respawn
  respawn limit 10 5
  # run as non privileged user 
  # add user with this command:
  ## adduser --system --ingroup www-data --home /opt/apache-tomcat apache-tomcat
  # Ubuntu 12.04: (use 'exec sudo -u apache-tomcat' when using 10.04)
  setuid ubuntu
  setgid ubuntu
  # adapt paths:
  
  exec /usr/bin/npm run start:dev
  # cleanup temp directory after stop
  post-stop script
  end script
EOF

# reload systemd services
sudo initctl reload-configuration
sudo initctl enable nodejs.service

# remove old directory
rm -rf /var/www/nodejs

# create directory node.js app
mkdir -p /var/www/nodejs 
