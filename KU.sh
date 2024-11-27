#!/bin/bash

# Function to prompt for username and create a new user
create_user() {
  read -p "Enter the username for the new user: " username
  sudo adduser $username
  echo "User $username created."
}

# Function to prompt for changing the root password
change_root_password() {
  echo "Please change the root password."
  sudo passwd root
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install essential tools
echo "Installing essential tools..."
sudo apt install -y curl wget git vim ufw fail2ban seclists

# Enable and configure UFW (Uncomplicated Firewall)
echo "Configuring UFW firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222/tcp
sudo ufw enable

# Set up Fail2Ban to protect against brute force attacks
echo "Setting up Fail2Ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Secure SSH by disabling root login and changing the default port
echo "Securing SSH..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create a new user without sudo privileges
create_user

# Prompt to change the root password
change_root_password

echo "Initial setup completed. Your system is updated and secured."
