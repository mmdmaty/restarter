#!/usr/bin/env bash

set -e

echo "=== Restarter Installer ==="


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/main.py"

echo "Script directory: $SCRIPT_DIR"


if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "❌ Error: main.py not found in $SCRIPT_DIR"
    exit 1
fi


echo "Choose interval mode:"
echo "  m = minutes"
echo "  h = hours"
read -p "Mode (m/h): " mode

if [[ "$mode" == "m" ]]; then
    read -p "Enter interval in minutes: " interval
    if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
        echo "❌ Interval must be a number"
        exit 1
    fi
    CRON_TIME="*/$interval * * * *"

elif [[ "$mode" == "h" ]]; then
    read -p "Enter interval in hours: " interval
    if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
        echo "❌ Interval must be a number"
        exit 1
    fi
    CRON_TIME="0 */$interval * * *"

else
    echo "❌ Invalid option. Choose 'm' or 'h'."
    exit 1
fi


CRON_TAG="# restarter-cron-job"


NEW_JOB="$CRON_TIME python3 $SCRIPT_PATH $CRON_TAG"


echo "Configuring cron job..."

(
    crontab -l 2>/dev/null | grep -v "$CRON_TAG"
    echo "$NEW_JOB"
) | crontab -


echo "--------------------------------------"
echo "✅ Installation complete!"
echo "📌 Cron job installed as:"
echo "$NEW_JOB"
echo "--------------------------------------"
