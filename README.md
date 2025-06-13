# Welcome to Helen's Submission Reminder App

A Bash-based Command Line app that helps monitor students who haven't submitted an assignment yet. Designed for automation, ease of updates, and interactivity, the application walks the user through setup and interaction steps.

---

## ✨ Features Overview

### Core Features (From Summative Instructions):

- **Environment Setup Script** (`create_environment.sh`)

  - Prompts for user's name
  - Creates a custom directory `submission_reminder_{yourName}`
  - Populates the structure with required files and folders
  - Makes `.sh` files executable
  - Adds read and write permision to .env and .txt files

- **Reminder System** (`startup.sh`, `reminder.sh`, `functions.sh`)

  - Reads a list of students from `submissions.txt`
  - Uses config (`config.env`) to find which assignment to check
  - Displays students who have not submitted

- **Assignment Update Script** (`copilot_shell_script.sh`)

  - Checks for the virtual environment folder, and asks the user to run the `create_environment.sh` first, if the folder does not exist
  - Asks the user to select the virtual environment to proceed with, if multiple virtual environment/Directories are found.
  - Lets users update the assignment name
  - Checks if the user entered an empty assignment name and keep bouncing them back
  - Automatically reruns the app with the new config
  - Updates the config row2 (Assignment value) to the new assignment name

### Additional Features Added:

- **User-friendly Menu Navigation** after each operation, an interactive menu shows up
- **Gives a valid response to the user when there is no student who haven't submitted an assignment**
- **Persistent directory structure checks**
- **Error handling with informative messages**
- \*\*Dynamic rerunning of scripts using \*\*\`\`
- **Color-coded terminal outputs**

---

## 📁 Project Structure

```
submission_reminder_app_GithubUsername/
├── create_environment.sh
├── copilot_shell_script.sh
├── README.md
└── submission_reminder_{yourName}/
    ├── startup.sh
    ├── app/
    │   └── reminder.sh
    ├── config/
    │   └── config.env
    ├── assets/
    │   └── submissions.txt
    └── modules/
        └── functions.sh
```

### File Descriptions:

- **create\_environment.sh** → Main setup script.
- **copilot\_shell\_script.sh** → Edits the assignment title in `config.env`.
- **startup.sh** → Entry point to the reminder functionality.
- **functions.sh** → Contains helper functions like the menu display, and the user option menu function for better navigation.
- **reminder.sh** → Checks `submissions.txt` and shows pending submissions.
- **submissions.txt** → Stores student records and submission statuses, well populated with 10 details.
- **config.env** → Stores the `ASSIGNMENT` value for dynamic checks.

---

## 📅 How the App Works

1. **Run** `create_environment.sh`

   - It asks for your name and creates a directory or virtual environment `submission_reminder_{yourName}`.
   - It creates necessary subfolders and adds provided script and data files.
   - It ensures all `.sh` files are executable.
   - After setup, it displays a menu to let you launch `startup.sh`, `copilot_shell_script.sh`, `restart the create_environment.sh` or `exit` automatically.

   <ins>Example output when running create_environment.sh</ins>:

<pre><code class="bash"> $ bash create_environment.sh Welcome to Helen's Submission Reminder App! 

Please enter your name: name here... 

Creating a virtual environment for you... 
Directory created: submission_reminder_helen 

All files and directories successufully setup. 

Choose what you want to do next </code></pre>

2. **Based on User selection - Launches** `startup.sh`

   - Loads `config.env` to get the current assignment name.
   - Calls `reminder.sh` to check for students who haven’t submitted.
   - Lists all students who haven't submitted that assignment.
   - Gives a valid message, if there is no student found.
   - Offers a menu:
     - Rerun the reminder
     - Restart environment setup
     - Change assignment via copilot script
     - Exit

3. **Run** `copilot_shell_script.sh`

   - Checks for the Virtual environment to use
   - Prompts for new assignment name.
   - Updates `config.env` using `sed`.
   - Displays the user option menu.

---

## ⚠️ Error Handling

- If the directory already exists, user is notified.
- If `submissions.txt` or `config.env` is missing, a clear error is shown.
- Invalid menu choices return feedback.
- Script paths are resolved using absolute paths to avoid execution issues.
- All major operations are wrapped in checks to ensure graceful failure.

---

## 🎓 Student Record Format

```
NAME,ASSIGNMENT,STATUS
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
```

- Ensure every record follows this CSV format.
- Assignment field should match the one in `config.env`.

---

## 📚 Git Branching Workflow

STEPS FOLLOWED:

- Developed code in a branch (`feature/setup`)
- Merged final scripts into the `main` branch

Only the following exists in `main` branch:

```
create_environment.sh
copilot_shell_script.sh
README.md
```

Other folders are dynamically generated by `create_environment.sh`, well-populated and automated.

---

## ⚡ How to Run the Application

1. **Clone my GitHub repo**:

```bash
git clone https://github.com/helen751/submission_reminder_app_Helen751.git
cd submission_reminder_app_Helen751
```

2. **Make the setup script executable (if needed, but should already be executable)**:

```bash
chmod +x create_environment.sh
```

3. **Run the environment setup**:

```bash
./create_environment.sh
```

4. **To run the reminder app**:

```bash
bash submisison_reminder_{yourname}/startup.sh
```

5. **To change assignment name**:

```bash
bash copilot_shell_script.sh
```

**NOTE: The app include a user option menu for better navigation, so you don't need to run all script manually.**

---

## ✨ Tips for Facilitator

- All menu navigations are handled inside `functions.sh`
- Each action logs meaningful progress output with colors
- All user prompts include input validation where necessary
- Absolute paths are used to prevent directory confusion
- `exec` ensures clean re-entry into scripts without duplicate nesting
- `sleep 1` adds a 1 seconds delay to the program for better flow.
- `Aside the helper function given inside `functions.sh`, I added one more function for the user menu option navigation
- Used color codes eg `e[32m - green color` to render messages in interactive colors

---

## 🚀 Future Improvements

- Adding logging to store submission check history
- Integrate CSV parser to support richer data formats
- Checking if the assignment name entered in copilot matches any assignment in submissions.txt
- Build a UI wrapper for non-terminal users

---

## 📅 Created by: Helen Ugoeze Okereke (Linux class - C2)

This project demonstrates Shell scripting mastery, Bash logic design, modular file execution, and user-centric CLI interaction.

---

**Repository Format:**

```
submission_reminder_app_Helen751
├── create_environment.sh
├── copilot_shell_script.sh
├── README.md
```

That’s all that is needed in the `main` branch. ✅

