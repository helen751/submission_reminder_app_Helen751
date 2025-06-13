#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all matching directories into an array to show to the user
project_dirs=()
while IFS= read -r dir; do
    project_dirs+=("$dir")
done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -name "submission_reminder_*")

# Check if any project directories with the correct pattern were found
if [ ${#project_dirs[@]} -eq 0 ]; then
    printf "\e[31mNo project directory found. Please run the create environment script first.\n\e[0m \n"
    exit 1
fi

# If only one project directory is found, set it as the PROJECT_DIR
if [ ${#project_dirs[@]} -eq 1 ]; then
    dir_name=$(basename "${project_dirs[0]}")
    echo -e "One project directory found: $dir_name \n"
    PROJECT_DIR="${project_dirs[0]}"
else
    # If multiple project directories are found, prompt the user to select one
    echo -e "\n Multiple project directories found:"
    for i in "${!project_dirs[@]}"; do
        dir_name=$(basename "${project_dirs[$i]}")
        echo "  [$i] $dir_name"
    done
    read -p "Enter the number of the project directory you want to use: " choice_d

    # Validate the user's choice
    if ! [[ "$choice_d" =~ ^[0-9]+$ ]] || [ "$choice_d" -ge "${#project_dirs[@]}" ]; then
        printf "\e[31mInvalid choice.\n\e[0m \n"
        #ask the user if they want to restart the program
        read -p "Do you want to restart the Copilot program? (yes/no): " choice_t
        if [[ "$choice_t" =~ ^(yes|y)$ ]]; then
            exec "$0"  # Restart the script
        else
            echo -e "\n\tExiting Helen's Submission Reminder App. Goodbye $name!\n"
            exit 1
        fi
    fi

    # Set the selected project directory
    PROJECT_DIR="${project_dirs[$choice_d]}"
fi

root_dir="$PROJECT_DIR"

# Export variable so functions file can access it
export root_dir

# Change to the project directory
cd "$PROJECT_DIR" || exit

# Correct path to source functions
source "modules/functions.sh"

# Check if the config file exists
if [[ ! -f "config/config.env" ]]; then
    printf "\e[31m\nConfiguration file not found. Please run the create environment script first.\n\e[0m \n"
    option_menu_after_setup
    exit 1
fi

# Load the configuration file if it exists
source config/config.env

# asking the user for the assignment name and validating the input to ensure it is not empty
while true; do
read -p "Enter the assignment name: " assignment_name
    if [[ -z "$assignment_name" ]]; then
        printf "\e[31mAssignment name cannot be empty.\e[0m\n"
        read -p "Do you want to restart the Copilot program? (yes/no): " choice_t
        if [[ "$choice_t" =~ ^(yes|y)$ ]]; then
            continue  # Re-prompt for assignment name
        else
            echo -e "\n\tExiting Helen's Submission Reminder App. Goodbye $name!\n"
            exit 1
        fi
    else
        break  # Valid assignment name entered, proceed
    fi
done



# Detect OS type for sed command to allow smooth running on both macOS and Linux
if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
else
    sed -i "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
fi

# Source the updated config file to reflect changes in the current session
source config/config.env

# Print the updated assignment name
printf "\nUpdated assignment to '\e[32m%s\e[0m' in Config file.\n\n" "$ASSIGNMENT"
sleep 1

# Function to ask the user what they want to do next (found in functions.sh)
option_menu_after_setup
