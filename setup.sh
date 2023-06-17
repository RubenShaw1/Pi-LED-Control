#!/bin/bash
cd ~
u="$USER"
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

cd ~
rm LED_Control -r
mkdir LED_Control
cd LED_Control
git clone https://github.com/RubenShaw1/Pi-LED-Control.git
systemctl stop LED-Control




pip install termcolor flask requests

PYTHON_SCRIPT="/home/$u/LED_Control/Pi-LED-Control/led.py"

SERVICE_FILE="/etc/systemd/system/LED-Control.service"

cat >$SERVICE_FILE <<EOL
[Unit]
Description=LED-Control
After=network.target

[Service]
ExecStart=/usr/bin/python3 $PYTHON_SCRIPT
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload


systemctl enable LED-Control
systemctl start LED-Control


systemctl status LED-Control
