#!/bin/bash



#### BASICS ####

# Update the package list
sudo apt-get -y update

# Install nano in case it is not installed
sudo apt-get -y install nano

# Set the timezone to New York
timedatectl set-timezone America/New_York

# Install ntp for time synchronization
sudo apt-get -y install ntp



#### MEMORY SWAP ####

# Create a swap file
sudo fallocate -l 8G /swapfile

# Make the swap file accessible to root
sudo chmod 600 /swapfile

# Verify permissions
ls -lh /swapfile

# Mark the file as swap space
sudo mkswap /swapfile

# Enable the swap file
sudo swapon /swapfile

# Verify that swap is available
sudo swapon --show
free -h

# To make the swapfile permanent, add the swap file information to the end of our /etc/fstab
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Set swappiness to 10 and apply the setting
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Set cache pressure setting and apply the setting
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p



#### LIMIT SSH ACCESS ####

# Disable root login
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password login
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart the SSH service
sudo systemctl restart ssh



#### RATE LIMITING ####

# Install fail2ban to secure against brute force attacks
sudo apt-get -y install fail2ban



#### FIREWALL ####

# Install ufw
sudo apt-get -y install ufw

# Enable ufw
sudo ufw enable

# Allow SSH
sudo ufw allow OpenSSH

# Allow ports required by CapRover
sudo ufw allow 80,443,3000,996,7946,4789,2377/tcp;
sudo ufw allow 7946,4789,2377/udp;

# Allow email ports
sudo ufw allow 25/tcp
sudo ufw allow 465/tcp
sudo ufw allow 587/tcp
sudo ufw allow 143/tcp
sudo ufw allow 993/tcp
sudo ufw allow 110/tcp
sudo ufw allow 995/tcp

# Reload ufw
sudo ufw reload



#### ROOTKIT HUNTER ####

# Install and configure rkhunter
sudo apt-get -y install rkhunter

# Update the rkhunter database
sudo rkhunter --update

# Run a rkhunter check
sudo rkhunter --check

# Add a cron job for rkhunter to update daily at midnight
(crontab -l 2>/dev/null; echo "0 0 * * * sudo rkhunter --update") | crontab -

# Add a cron job for rkhunter to run daily at 2 am
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/rkhunter --check --cronjob") | crontab -



#### LYNIS ####

# Install and configure lynis
sudo apt-get -y install lynis

# Run a lynis audit
sudo lynis audit system

# Add a cron job for rkhunter to run daily at 3 am
(crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/rkhunter --check --cronjob") | crontab -



#### AUTOMATIC SECURITY UPDATES ####

# Install and configure unattended-upgrades
sudo apt-get -y install unattended-upgrades

# Enable unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades



#### CLAMAV ####

# Install and configure clamav and its daemon
sudo apt-get -y install clamav clamav-daemon

# Update the clamav database
sudo freshclam

# Enable and Start the ClamAV Daemon:
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon

# Add a cron job for freshclam to update the database every day at 3am
(crontab -l 2>/dev/null; echo "0 4 * * * sudo freshclam") | crontab -

# Install and configure clamtk
sudo apt-get -y install clamtk

# Install and configure clamav-unofficial-sigs
sudo apt-get -y install clamav-unofficial-sigs


#### DOCKER ####

# Update the package database
sudo apt-get -y update

# Install required packages
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database again
sudo apt-get -y update

# Install Docker
sudo apt-get -y install docker-ce

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Refresh the current user’s group membership
newgrp docker

# Start the Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Verify Docker installation
docker --version



#### CAPROVER ####

docker run -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
