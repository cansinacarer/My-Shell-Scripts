# My Shell Scripts

My scripts for bundling multiple commands into one on Windows and Linux.

## new-server-initialization

Contains the scripts for quickly setting up a new Ubuntu server.

### `new-server-root-scripts.sh`:

curl-pipe-bash one-liner:

```sh
curl -fsSL https://raw.githubusercontent.com/cansinacarer/My-Shell-Scripts/refs/heads/main/new-server-initialization/new-server-root-scripts.sh | sudo bash
```

This script assumes we created a new instance with an ssh key selected on Hetzner or similar, which is by default used to ssh in with root.

Running this script as root:

- Creates a user without a password, with sudo privileges and no password prompt for sudo commands.
- Copies root's authorized SSH keys to the new user so they can log in immediately.
- Disables root SSH login and password authentication via a drop-in sshd config.
- Validates the sshd config and reloads the SSH service.

To confirm that the new user can ssh in with the same key and run sudo commands:

```sh
ssh cansin@<server-ip>
sudo whoami # should print 'root'
```

### `new-server-user-scripts.sh`:

curl-pipe-bash one-liner:

```sh
curl -fsSL https://raw.githubusercontent.com/cansinacarer/My-Shell-Scripts/refs/heads/main/new-server-initialization/new-server-user-scripts.sh | sudo bash
```

Running this script as the newly created user:

- Wipes root's SSH authorized_keys (confirming the new user works).
- Sets timezone and installs basic utilities.
- Creates an 8GB swap file with tuned swappiness and cache pressure.
- Installs fail2ban, ufw firewall (with Coolify ports open).
- Sets up unattended-upgrades.
- Runs the Coolify installer (which handles Docker setup itself).

## SSH

### `servers`

A Linux CLI that shows a list of your servers and you just select the one you want to SSH into. Requires you to configure the credentials/SSH keys in advance.

## Git

### `makerepo`

Add this repo to path, then you can call any of the scripts below from any directory.

You must have GitHub CLI and git installed and configured before using these scripts.

1. Initializes a repository,
2. Adds everything in the current directory to stage,
3. Commits everything stages with the message "first commit" (customizable),
4. Creates a Github repo using the name of the current directory as the repo name, adds it as remote,
5. Pushes everything to the newly created remote repo.

### `acp`

Combines git

- Adds all changes to stage,
- Commits with customizable message,
- Pushes.

## Ubuntu Desktop

### `show-hide-mounted-drives-on-ubuntu-desktop`

Scripts to shows and hide the mounted drives on Ubuntu Desktop.
