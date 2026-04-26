#!/usr/bin/env bash

set -e

echo "=== Restarter Installer ==="

# پیدا کردن مسیر اسکریپت
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Script directory: $SCRIPT_DIR"

read -p "Run cron job by minutes or hours? (m/h): " mode

if [[ "$mode" == "m" ]]; then
    read -p "Enter interval in minutes: " interval
    CRON_TIME="*/$interval * * * *"
elif [[ "$mode" == "h" ]]; then
    read -p "Enter interval in hours: " interval
    CRON_TIME="0 */$interval * * *"
else
    echo "Invalid option"
    exit 1
fi

SCRIPT_PATH="$SCRIPT_DIR/main.py"

if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "Error: main.py not found in $SCRIPT_DIR"
    exit 1
fi

echo "Setting cron job..."

(crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH"; echo "$CRON_TIME python3 $SCRIPT_PATH") | crontab -

echo "✅ Installation complete"
echo "Cron schedule: $CRON_TIME"
