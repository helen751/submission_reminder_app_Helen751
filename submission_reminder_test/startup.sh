#!/bin/bash

# Startup script for Submission Reminder App
# Get the directory this script is in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the app directory relative to the script
cd "$SCRIPT_DIR/app" || exit

# Run the reminder script
./reminder.sh
