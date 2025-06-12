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
