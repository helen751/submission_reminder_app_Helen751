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
    echo "One project directory found: $dir_name \n"
else
# If multiple project directories are found, prompt the user to select one
    echo -e "\n Multiple project directories found:"
    for i in "${!project_dirs[@]}"; do
        dir_name=$(basename "${project_dirs[$i]}")
        echo "  [$i] $dir_name"
    done
    read -p "Enter the number of the project directory you want to use: " choice

# Validate the user's choice
    # Check if the input is a valid number and within the range of available directories
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#project_dirs[@]}" ]; then
        printf "\e[31mInvalid choice.\n\e[0m \n"
        exit 1
    fi

    # Set the selected project directory
    PROJECT_DIR="${project_dirs[$choice]}"
fi

# Change to the project directory
cd "$PROJECT_DIR" || exit

# Check if the config file exists
if [[ ! -f "config/config.env" ]]; then
    # If the config file does not exist, print an error message in red color and exit
    printf "\e[31m\nConfiguration file not found. Please run the create environment script first.\n\e[0m \n"

    exit 1
fi

# Load the configuration file if it exists
source config/config.env

# asking the user for the assignment name
read -p "Enter the assignment name: " assignment_name

# Detect OS type for sed command to allow smooth running on both macOS and Linux
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    sed -i '' "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
else
    # Linux and others
    sed -i "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
fi

#source the updated config file to reflect changes in the current session
source config/config.env

# Print the updated assignment name
printf "\nUpdated assignment to '\e[32m%s\e[0m' in Config file.\n\n" "$ASSIGNMENT"

#asking if the user wants to run the startup script now, exit the app or rerun the copilot script
read -p "Do you want to run the startup script now? (y/n): " run_now
if [[ "$run_now" == "y" || "$run_now" == "Y" ]]; then
    # Run the startup script
    echo -e "\n\tRunning the startup script...\n"
    bash "$PROJECT_DIR/startup.sh"
else
#asking if the user wants to rerun the copilot script or exit the app
    read -p "Do you want to rerun the copilot script? (y/n): " rerun_copilot
    if [[ "$rerun_copilot" == "y" || "$rerun_copilot" == "Y" ]]; then
        echo -e "\n\tRerunning the copilot script...\n"
        cd "$SCRIPT_DIR" || exit
        bash copilot_shell_script.sh
    fi
    # Exit the app
    echo -e "\n\tExiting the app. You can run the startup or Copilot script later.\n"
    exit 0
fi
