#!/usr/bin/env bash

set -e

echo "=== Restarter Installer ==="

# Project target directory
INSTALL_DIR="/opt/restarter"
REPO_URL="https://github.com/mmdmaty/restarter.git"

# Detect if script is being piped (curl|bash) or run locally
if [[ -d "$(dirname "${BASH_SOURCE[0]}")" && -f "$(dirname "${BASH_SOURCE[0]}")/main.py" ]]; then
    # Local execution (manual install)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "Local install detected."
else
    # Piped execution → need to git clone
    echo "Online install detected (curl | bash)."
    echo "Cloning repository into $INSTALL_DIR ..."

    sudo rm -rf "$INSTALL_DIR"
    sudo git clone "$REPO_URL" "$INSTALL_DIR"

    SCRIPT_DIR="$INSTALL_DIR"
fi

SCRIPT_PATH="$SCRIPT_DIR/main.py"
echo "Using project directory: $SCRIPT_DIR"

# Ensure main.py exists now
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "❌ ERROR: main.py not found in $SCRIPT_DIR"
    exit 1
fi

# Ask for cron mode
echo "Choose interval mode:"
echo "  m = minutes"
echo "  h = hours"
read -p "Mode (m/h): " mode

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

# Cron tag
CRON_TAG="# restarter-cron-job"
NEW_JOB="$CRON_TIME python3 $SCRIPT_PATH $CRON_TAG"

echo "Configuring cron..."

(
    crontab -l 2>/dev/null | grep -v "$CRON_TAG"
    echo "$NEW_JOB"
) | crontab -

echo "--------------------------------------"
echo "✅ Installation complete!"
echo "📌 Cron job installed:"
echo "    $NEW_JOB"
echo "📌 Installed directory:"
echo "    $SCRIPT_DIR"
echo "--------------------------------------"
