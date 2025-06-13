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

