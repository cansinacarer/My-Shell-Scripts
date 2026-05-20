#!/bin/bash
#
# Hetzner SSH hardening: create non-root user with SSH key access and
# passwordless sudo, then disable root SSH login.
#
# Run as root on a fresh Hetzner server. Test the new user in a separate
# terminal before disconnecting your root session.

set -euo pipefail

# Define the username
USERNAME="cansin"

# Create user without a password (key-only auth, no password needed anywhere)
adduser --disabled-password --gecos "" "$USERNAME"
usermod -aG sudo "$USERNAME"

# Copy root's SSH key to the new user
mkdir -p "/home/$USERNAME/.ssh"
cp /root/.ssh/authorized_keys "/home/$USERNAME/.ssh/authorized_keys"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"
chmod 700 "/home/$USERNAME/.ssh"
chmod 600 "/home/$USERNAME/.ssh/authorized_keys"

# Enable passwordless sudo for this user
SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
visudo -cf "$SUDOERS_FILE"

# Harden SSH: disable root login and password auth
HARDENING_FILE="/etc/ssh/sshd_config.d/99-hardening.conf"
cat > "$HARDENING_FILE" <<EOF
PermitRootLogin prohibit-password
PasswordAuthentication no
PubkeyAuthentication yes
EOF
chmod 644 "$HARDENING_FILE"

# Validate sshd config before reloading
sshd -t

# Reload sshd to apply changes
systemctl reload ssh

echo ""
echo "Done. Before closing this root session, open a new terminal and verify:"
echo "  ssh $USERNAME@<server-ip>"
echo "  sudo whoami    # should print 'root' with no password prompt"
echo ""
echo "Once confirmed, run the user script as your new user."