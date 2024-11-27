#!/bin/bash

# Function to install xwinwrap and its dependencies
install_xwinwrap() {
    echo "Updating system and installing dependencies..."
    sudo apt update
    sudo apt install -y xwinwrap mpv

    # Download and install xwinwrap
    echo "Downloading and installing xwinwrap..."
    git clone https://github.com/ujjwal96/xwinwrap.git
    cd xwinwrap
    make
    sudo make install
    cd ..
    rm -rf xwinwrap
    echo "xwinwrap installation complete."
}

# Function to set GIF as wallpaper
set_gif_wallpaper() {
    read -p "Enter the full path to your .gif file: " gifpath
    if [ -f "$gifpath" ]; then
        echo "Setting up the GIF wallpaper..."
        xwinwrap -ov -fs -- mpv --wid=%WID --loop-file=inf "$gifpath" &
        echo "GIF wallpaper set successfully!"
    else
        echo "File not found. Please check the path and try again."
    fi
}

# Main script execution
install_xwinwrap
set_gif_wallpaper

echo "Script execution complete."
