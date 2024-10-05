#!/bin/bash

# Function to display a progress bar
show_progress() {
    local progress=0
    local total=100
    local bar_length=50
    local filled_length=0
    local empty_length=0
    local percentage=0

    while [ $progress -le $total ]; do
        filled_length=$((progress * bar_length / total))
        empty_length=$((bar_length - filled_length))
        percentage=$((progress * 100 / total))

        printf "\r["
        printf "%0.s#" $(seq 1 $filled_length)
        printf "%0.s-" $(seq 1 $empty_length)
        printf "] %d%%" $percentage

        sleep 0.1
        progress=$((progress + 1))
    done
    echo ""
}

# Function to check for updates and display them
check_updates() {
    echo "Checking for updates..."
    sudo apt update -y > /dev/null 2>&1
    updates=$(apt list --upgradable 2>/dev/null | grep -v "Listing...")
    if [ -z "$updates" ]; then
        echo "No updates available."
        exit 0
    else
        echo "The following updates are available:"
        echo "$updates"
    fi
}

# Function to prompt the user to continue
prompt_user() {
    read -p "Do you want to apply these updates? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Applying updates...";;
        n|N ) echo "Updates canceled."; exit 0;;
        * ) echo "Invalid choice."; prompt_user;;
    esac
}

# Function to apply updates
apply_updates() {
    echo "Updating and upgrading the system..."
    show_progress &
    progress_pid=$!
    sudo apt upgrade -y > /dev/null 2>&1
    sudo apt full-upgrade -y > /dev/null 2>&1
    sudo apt autoremove -y > /dev/null 2>&1
    sudo apt clean > /dev/null 2>&1
    kill $progress_pid
    echo "System updated successfully!"
}

# Main script execution
check_updates
prompt_user
apply_updates
