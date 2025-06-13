#!/bin/bash

#root directory for the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if the script is being sourced or executed for exiting logic
is_sourced() {
  [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

# function to call the options menu once to avoid duplicate calling 
SHOW_MENU=true
if [[ "$1" == "--no-menu" ]]; then
    SHOW_MENU=false
fi

#welcome message
echo -e "\n\t WELCOME TO HELEN'S SUBMISSION REMINDER APP\n"
sleep 1

# Prompting the user for their name and validating input until a valid name is entered
while true; do
    read -p "Please enter your name: " name

    if [ -z "$name" ]; then
        printf "\e[31mName cannot be empty.\e[0m\n"
        read -p "Do you want to restart the program? (yes/no): " choice_t
        if [[ "$choice_t" =~ ^(yes|y)$ ]]; then
            continue  # Re-prompt for name
        else
            printf "\n\e[33m\tExiting Helen's Submission Reminder App. Goodbye!\n\e[0m\n"
            if is_sourced; then
                return 1
            else
                exit 1
            fi
        fi
    else
        break  # Valid name entered, proceed
    fi
done

# Defensive check to ensure the name variable is not empty
if [ -z "$name" ]; then
    if is_sourced; then
        return 1
    else
        exit 1
    fi
fi

#exporting the name variable so that it can be used in other scripts
export name

# Starting automation
echo -e "\n\tCreating a virtual environment for you..."

#setting the root directory for the app environment
root_dir="$script_dir/submission_reminder_${name}"

# Checking if the virtual environment directory already exists
if [ -d "$root_dir" ]; then
    printf "\e[33mDirectory '$root_dir' already exists. Skipping creation.\e[0m \n"

    #asking the user if they want to delete the existing directory and create a new one or continue to run the startup script
    read -p "Do you want to delete the existing directory and create a new one? (yes/no): " delete_choice
    if [[ "$delete_choice" == "yes" || "$delete_choice" == "y" ]]; then
        rm -rf "$root_dir"

        #message in yellow color to indicate that the existing directory has been deleted
        printf "\e[33mDeleted the existing directory '$root_dir'.\e[0m \n"
        mkdir "$root_dir"

        #checking if the directory was created successfully
        if [ $? -ne 0 ]; then
            printf "\e[31mFailed to create the directory. Run the script again.\n\e[0m \n"
            
        fi
    else
        # If the user chooses not to delete, continue with the existing directory and run the startup script since everything is already set up
        echo "Continuing with the existing directory '$root_dir'. go ahead and run the startup script."
        
        #calling the option menu after setup to ask the user what they want to do next
        source "$root_dir/modules/functions.sh"
        option_menu_after_setup
    fi
else
    mkdir "$root_dir"
    if [ $? -ne 0 ]; then
        printf "\e[31mFailed to create the directory. Exiting.\n\e[0m \n"
        exit 0
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

#creating the functions file
echo -e "\n\tCreating the functions file..."
cat > "$root_dir/modules/functions.sh" <<'EOL'
#!/bin/bash

#for a better user experience, I added one more functions to this original functions file
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    #setting a variable to count if there are unsubmitted assignments
    found_unsubmitted=0
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
            printf "\e[31mReminder: $student has not submitted the $ASSIGNMENT assignment!\e[0m \n"
            found_unsubmitted=1
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
    # If no unsubmitted assignments were found, print a success message
    if [[ "$found_unsubmitted" -eq 0 ]]; then
    printf "\e[32mNo students found who have not submitted this assignment.\e[0m\n\n"
    fi
}

#option menu function to ask the user if they want to:
#run the startup script now, 
#restart the creat envrionment script, 
#run the copilot script or 
#exit the app after the environment has been created for better user experience
function option_menu_after_setup {
    echo -e "\n\tWhat would you like to do next?"
    echo -e "\t1. Run the startup script now"
    echo -e "\t2. Restart the create environment script"
    echo -e "\t3. Run the copilot script"
    echo -e "\t4. Exit the app"

    read -p "Please enter your choice (1-4): " choice

    case $choice in
        1)
            clear
            printf "\n\e[32m\tRunning the startup script...\n\e[0m\n"
            exec bash "$root_dir/startup.sh"
            sleep 1
            ;;
        2)
            clear
            printf "\n\e[32m\tRestarting the create environment script...\n\e[0m\n"
            sleep 1
            exec bash $root_dir/../create_environment.sh --no-menu
            ;;
        3)
            clear
            printf "\n\e[32m\tRunning the copilot script...\n\e[0m\n"
            sleep 1
            exec bash $root_dir/../copilot_shell_script.sh
            ;;
        4)
            
            printf "\n\e[33m\tExiting Helen's Submission Reminder App. Goodbye, $name!\n\e[0m\n"
            exit 0
            ;;
        *)
            printf "\n\e[31mInvalid choice. Exiting.\n\e[0m\n"
            exit 1
            ;;
    esac
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

# Set the root directory dynamically to the project root
root_dir="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/../" && pwd)"
# Export so it's available in functions
export root_dir

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

#calling the option menu after setup to ask the user what they want to do next
option_menu_after_setup
EOL

sleep 1
echo -e "\n\tReminder script created successfully!"

# adding permissions for the created files and directories
chmod +x "$root_dir/app/reminder.sh"
chmod +x "$root_dir/modules/functions.sh"
chmod 644 "$root_dir/config/config.env"
chmod 644 "$root_dir/assets/submissions.txt"

printf "\n\t\e[32mAll Files and directories created successfully!\e[0m\n\n"

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
printf "\n\t\e[32mStartup script set up successfully!\e[0m\n\n"

#source the functions file to use the option menu after setup
source "$root_dir/modules/functions.sh"
if [ "$SHOW_MENU" = true ]; then
    option_menu_after_setup
fi
# End of script









