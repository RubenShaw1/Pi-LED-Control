#!/bin/bash

u="$USER"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

SCRIPT_DIR="/home/$u/LED_Control"


if [ -d "$SCRIPT_DIR" ]; then
  systemctl stop LED-Control
  rm "$SCRIPT_DIR" -r
fi


cd /home/"$u" || exit
git clone https://github.com/RubenShaw1/Pi-LED-Control.git "$SCRIPT_DIR"


pip install flask termcolor


PYTHON_SCRIPT="$SCRIPT_DIR/led.py"

SERVICE_FILE="/etc/systemd/system/LED-Control.service"

cat >"$SERVICE_FILE" <<EOL
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
