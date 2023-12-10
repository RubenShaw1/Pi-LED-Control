#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

CURRENT_USER=$SUDO_USER


if [ -z "$CURRENT_USER" ]; then
  echo "Unable to determine the invoking user."
  exit 1
fi


SCRIPT_DIR="/home/$CURRENT_USER/LED_Control"

# Create the directory if it doesn't exist
if [ ! -d "$SCRIPT_DIR" ]; then
  mkdir -p "$SCRIPT_DIR"
fi


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
