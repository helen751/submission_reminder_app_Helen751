#!/bin/bash

#welcome message
echo -e "\n\t WELCOME TO HELEN'S SUBMISSION REMINDER APP\n"
sleep 1

# Prompt user for their name
read -p "Please enter your name: " name

# Check if the name is empty
if [ -z "$name" ]; then
    echo "Name cannot be empty. Exiting."
    exit 1
fi
# Create a directory for the submission reminder app
echo -e "\n\tCreating a virtual environment for you...\n"

root_dir="submission_reminder_${name}"
if [ -d "$root_dir" ]; then
    echo "Directory '$root_dir' already exists. Skipping creation."
else
    mkdir "$root_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to create the directory. Exiting."
        exit 1
    fi
fi
sleep 1
echo -e "\n\tVirtual environment created successfully!\n"

echo -e "\n\tSetting up the app structure with directories and files...\n"
mkdir "$root_dir/app"
mkdir "$root_dir/modules"
mkdir "$root_dir/assets"
mkdir "$root_dir/config"
touch "$root_dir/startup.sh"
sleep 1
echo -e "\n\tApp structure set up successfully!\n"

# Create configurationfile
echo -e "\n\tCreating configuration file\n"
cat > "$root_dir/config/config.env" <<EOL
# Configuration file for Submission Reminder App
ASSIGNMENT="Assignment 1"
DAYS_REMAINING=7
EOL

sleep 1
echo -e "\n\tConfiguration file created successfully!\n"

#creating the funcions file
echo -e "\n\tCreating the functions file...\n"
cat > "$root_dir/modules/functions.sh" <<EOL
# Helper functions for Submission Reminder App
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL
sleep 1
echo -e "\n\tFunctions file created successfully!\n"

# Creating a sample submissions file
echo -e "\n\tCreating a sample submissions file...\n"
cat > "$root_dir/assets/submissions.txt" <<EOL
# Submissions file format: student, assignment, status
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Helen, Python Loop, submitted
Wisdom, Shell variables, not submitted
Favour, Git branches, not submitted
Ugoeze, Rust basics, submitted
Peace, HTML tags, submitted
EOL

sleep 1
echo -e "\n\tSample submissions file created successfully!\n"

# Creating the reminder script
echo -e "\n\tCreating the reminder script...\n"
cat > "$root_dir/app/reminder.sh" <<'EOL'
#!/bin/bash
# Source environment variables and helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
# Source environment variables and helper functions
source "$ROOT_DIR/config/config.env"
source "$ROOT_DIR/modules/functions.sh"
# Path to the submissions file
submissions_file="$ROOT_DIR/assets/submissions.txt"
# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"
check_submissions "$submissions_file"
EOL

sleep 1
echo -e "\n\tReminder script created successfully!\n"

# adding permissions for the created files and directories
chmod +x "$root_dir/app/reminder.sh"
chmod +x "$root_dir/config/config.env"
chmod +x "$root_dir/modules/functions.sh"
chmod +x "$root_dir/assets/submissions.txt"

echo -e "\n\tFiles and directories created successfully!\n"
echo -e "\n\tSetting up the startup script...\n"

#creating the startup script
cat > "$root_dir/startup.sh" <<EOL
#!/bin/bash
# Startup script for Submission Reminder App
# Navigate to the app directory
cd "$root_dir/app" || exit
# Run the reminder script
./reminder.sh
EOL

# Making the startup script executable
chmod +x "$root_dir/startup.sh"
echo -e "\n\tStartup script set up successfully!\n"
echo -e "\n\tYou can now run the app by executing the startup script:\n"
echo -e "\t\$ bash $root_dir/startup.sh\n"
echo -e "\n\tThank you for using Helen's Submission Reminder App!\n"
echo -e "\n\tHave a great day, $name!\n"







