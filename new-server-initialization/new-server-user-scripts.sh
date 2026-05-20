#!/bin/bash
#
# Server setup: run as the non-root user (e.g. cansin) after harden-ssh.sh.
# Installs swap, firewall, and Coolify (which installs Docker itself).

set -euo pipefail

# Config
TIMEZONE="America/Los_Angeles"
SWAP_SIZE="8G"


#### WIPE ROOT'S SSH KEY ####

# Now that we've confirmed login as this user works, remove root's authorized_keys
sudo truncate -s 0 /root/.ssh/authorized_keys



#### BASICS ####

# Update the package list
sudo apt-get -y update

# Install nano in case it is not installed
sudo apt-get -y install nano

# Set the timezone
sudo timedatectl set-timezone "$TIMEZONE"

# Verify server time
echo "=== Time sync status ==="
timedatectl status
echo "========================"



#### MEMORY SWAP ####

# Only create swap if it doesn't already exist
if [ ! -f /swapfile ]; then

    # Create a swap file
    sudo fallocate -l "$SWAP_SIZE" /swapfile

    # Make the swap file accessible to root
    sudo chmod 600 /swapfile

    # Verify permissions
    ls -lh /swapfile

    # Mark the file as swap space
    sudo mkswap /swapfile

    # Enable the swap file
    sudo swapon /swapfile

    # To make the swapfile permanent, add the swap file information to the end of our /etc/fstab
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

    # Set swappiness to 10 and apply the setting
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    # Set cache pressure setting and apply the setting
    echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

fi

# Verify swap is available
sudo swapon --show
free -h



#### RATE LIMITING ####

# Install fail2ban to secure against brute force attacks
sudo apt-get -y install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban



#### FIREWALL ####

sudo apt-get -y install ufw

# Allow SSH first to avoid locking ourselves out
sudo ufw allow OpenSSH

# Coolify ports: 80/443 for deployed apps, 8000 for the Coolify dashboard
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp

# Enable non-interactively (default would prompt y/n)
sudo ufw --force enable
sudo ufw reload



#### AUTOMATIC SECURITY UPDATES ####

# Install and configure unattended-upgrades
sudo apt-get -y install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades



#### COOLIFY ####

# Coolify's installer handles Docker installation automatically
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | sudo bash



echo ""
echo "Setup complete."
echo ""
echo "Next step: open the Coolify dashboard at http://<server-ip>:8000"