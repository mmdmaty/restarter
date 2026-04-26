#!/bin/bash

echo "=== Installer ==="

read -p "Run cron job by minutes or hours? (m/h): " mode

if [ "$mode" = "m" ]; then
    read -p "Enter interval in minutes: " interval
    cron_time="*/$interval * * * *"
elif [ "$mode" = "h" ]; then
    read -p "Enter interval in hours: " interval
    cron_time="0 */$interval * * *"
else
    echo "Invalid option"
    exit 1
fi

INSTALL_DIR="$HOME/my_script"

echo "Creating directory..."
mkdir -p $INSTALL_DIR

echo "Downloading project..."
git clone https://github.com/USERNAME/REPO.git $INSTALL_DIR

SCRIPT_PATH="$INSTALL_DIR/main.py"

echo "Setting cron job..."

(crontab -l 2>/dev/null; echo "$cron_time python3 $SCRIPT_PATH") | crontab -

echo "✅ Installed successfully!"
echo "Cron schedule: $cron_time"
