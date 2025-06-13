#!/bin/bash

# Set the root directory dynamically to the project root
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
# Export so it's available in functions
export root_dir

# Source environment variables and helper functions
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")

source "$ROOT_DIR/config/config.env"
source "$ROOT_DIR/modules/functions.sh"

# Path to the submissions file
submissions_file="$ROOT_DIR/assets/submissions.txt"

# Print remaining time and run the reminder function
echo -e "\n\n\tAssignment: $ASSIGNMENT"
echo -e "\tDays remaining to submit: $DAYS_REMAINING days"
echo "------------------------------------------------"

check_submissions "$submissions_file"

#calling the option menu after setup to ask the user what they want to do next
option_menu_after_setup
