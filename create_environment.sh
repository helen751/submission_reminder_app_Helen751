#!/bin/bash

#creating an option menu function for better user experience when they enter an invalid name
function option_menu {
#asking the user if they want to restart the program or exit after entering an invalid name
    read -p "Do you want to restart the program? (yes/no): " choice
    if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
        echo -e "\n\tRestarting the program...\n"
        exec "$0"  # Restart the script
    else
        echo -e "\n\tExiting Helen's Submission Reminder App. Goodbye, $name!\n"
        exit 0
    fi
}


#welcome message
echo -e "\n\t WELCOME TO HELEN'S SUBMISSION REMINDER APP\n"
sleep 1

# Prompt user for their name
read -p "Please enter your name: " name

# Check if the user entered an empty name
if [ -z "$name" ]; then
    echo "Name cannot be empty. Exiting."
    
    #calling the option menu function to ask the user if they want to restart the program or exit
    option_menu
fi

# Creating a directory for the user in the submission reminder app
echo -e "\n\tCreating a virtual environment for you..."

# Checking if the virtual environment directory already exists
root_dir="submission_reminder_${name}"
if [ -d "$root_dir" ]; then
    echo "Directory '$root_dir' already exists. Skipping creation."

    #asking the user if they want to delete the existing directory and create a new one or continue to run the startup script
    read -p "Do you want to delete the existing directory and create a new one? (yes/no): " delete_choice
    if [[ "$delete_choice" == "yes" || "$delete_choice" == "y" ]]; then
        rm -rf "$root_dir"
        echo "Deleted the existing directory '$root_dir'."
        mkdir "$root_dir"

        #checking if the directory was created successfully
        if [ $? -ne 0 ]; then
            echo "Failed to create the directory. Exiting."
            exit 1
        fi
    else
        # If the user chooses not to delete, continue with the existing directory and run the startup script since everything is already set up
        echo "Continuing with the existing directory '$root_dir'. go ahead and run the startup script."
        echo -e "\n\tYou can run the startup script later by executing:"
        echo -e "\t\$ bash $root_dir/startup.sh\n"
        exit 1
    fi
else
    mkdir "$root_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to create the directory. Exiting."
        exit 1
    fi
fi
sleep 1
echo -e "\n\tVirtual environment created successfully!\n"

# Setting up the app structure including the directories and files
echo -e "\n\tSetting up the app structure with directories and files..."
mkdir "$root_dir/app"
mkdir "$root_dir/modules"
mkdir "$root_dir/assets"
mkdir "$root_dir/config"
touch "$root_dir/startup.sh"
sleep 1
echo -e "\n\tApp structure set up successfully!\n"

# Creating the configuration file
echo -e "\n\tCreating configuration file"
cat > "$root_dir/config/config.env" <<EOL
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

sleep 1
echo -e "\n\tConfiguration file created successfully!\n"

#creating the funcions file
echo -e "\n\tCreating the functions file..."
cat > "$root_dir/modules/functions.sh" <<'EOL'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions ..."
    sleep 1

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then

            # Print a reminder message in red color
            # Using ANSI escape codes to print in red
            printf "\e[31mReminder: $student has not submitted the $ASSIGNMENT assignment!\e[0m \n"

        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL
sleep 1
echo -e "\n\tFunctions file created successfully!\n"

# Creating a sample submissions file
echo -e "\n\tCreating a sample submissions file..."
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

# Creating the reminder script and populating it with the given code
echo -e "\n\tCreating the reminder script..."
cat > "$root_dir/app/reminder.sh" <<EOL
#!/bin/bash

# Source environment variables and helper functions
SCRIPT_DIR=\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=\$(dirname "\$SCRIPT_DIR")

source "\$ROOT_DIR/config/config.env"
source "\$ROOT_DIR/modules/functions.sh"

# Path to the submissions file
submissions_file="\$ROOT_DIR/assets/submissions.txt"

# Print remaining time and run the reminder function
echo -e "\\n\\n\tAssignment: \$ASSIGNMENT"
echo -e "\tDays remaining to submit: \$DAYS_REMAINING days"
echo "------------------------------------------------"

check_submissions "\$submissions_file"
EOL

sleep 1
echo -e "\n\tReminder script created successfully!"

# adding permissions for the created files and directories
chmod +x "$root_dir/app/reminder.sh"
chmod +x "$root_dir/config/config.env"
chmod +x "$root_dir/modules/functions.sh"
chmod +x "$root_dir/assets/submissions.txt"

echo -e "\n\tAll Files and directories created successfully!\n"
echo -e "\n\tSetting up the startup script..."

#creating the startup script that will run the reminder script
cat > "$root_dir/startup.sh" <<'EOL'
#!/bin/bash

# Startup script for Submission Reminder App
# Get the directory this script is in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the app directory relative to the script
cd "$SCRIPT_DIR/app" || exit

# Run the reminder script
./reminder.sh
EOL

# Making the startup script executable
chmod +x "$root_dir/startup.sh"

#adding a little delay before the final message
sleep 1
echo -e "\n\tStartup script set up successfully!\n"


#asking the user to type y if they want to run the startup script now
read -p "Do you want to run the startup script now? (y/n): " run_now

if [[ "$run_now" == "Y" || "$run_now" == "y" ]]; then
    echo -e "\n\tRunning the startup script...\n"
    bash "$root_dir/startup.sh"
else
    echo -e "\n\tYou can run the startup script later by executing:"
    echo -e "\t\$ bash $root_dir/startup.sh\n"

    #adding a thank you message
    echo -e "\n\tThank you for using Helen's Submission Reminder App!"
    echo -e "\n\tHave a great day, $name!\n"
fi









