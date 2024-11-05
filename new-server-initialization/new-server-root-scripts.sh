#!/bin/bash

# Define the username
USER="cansin"

# Add cansin as a user without a password
useradd -m -s /bin/bash $USER

# Give cansin sudo privileges
usermod -aG sudo $USER

# Define the SSH key file path
KEY_PATH="/home/$USER/.ssh/id_rsa"

# Create the .ssh directory if it doesn't exist
mkdir -p /home/$USER/.ssh

# Generate the SSH key pair with the correct comment
ssh-keygen -t rsa -b 2048 -f $KEY_PATH -N "" -C "$USER@$(hostname)"

# Set the correct permissions for the .ssh directory and the key files
chown -R $USER:$USER /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
chmod 600 $KEY_PATH
chmod 644 ${KEY_PATH}.pub

# Add the public key to the authorized_keys file
cat ${KEY_PATH}.pub >> /home/$USER/.ssh/authorized_keys
chmod 600 /home/$USER/.ssh/authorized_keys

# Print the generated key pair
echo -e "\n\nPrivate Key:"
cat $KEY_PATH
echo -e "\n\nPublic Key:"
cat ${KEY_PATH}.pub

echo -e "\n\nDo not forget to run chmod 600 /home/cansin/.ssh/KEYNAME.ppk on your device to be able to use this key!"

echo -e "\n\nSSH key pair created for user $USER at $KEY_PATH"