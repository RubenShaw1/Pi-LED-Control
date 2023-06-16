#!/bin/bash
cd ~
mkdir LED_Control
cd LED_Control
git clone https://github.com/RubenShaw1/Pi-LED-Control.git



if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

PYTHON_SCRIPT="$PWD/led.py"

# Create a Systemd service unit file
SERVICE_FILE="/etc/systemd/system/LED-Control.service"

# Write the service unit file
cat >$SERVICE_FILE <<EOL
[Unit]
Description=LED-Control
After=network.target

[Service]
ExecStart=/usr/bin/python3 $PYTHON_SCRIPT
WorkingDirectory=$(dirname "$PYTHON_SCRIPT")
User=nobody
Group=nogroup
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload


systemctl enable LED-Control
systemctl start LED-Control


systemctl status LED-Control
