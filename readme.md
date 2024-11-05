# My Shell Scripts

My scripts for bundling multiple commands into one on Windows and Linux.

## new-server-initialization

Contains the scripts for quickly setting up a new Ubuntu server:

- `new-server-root-scripts.sh`:
  - Creates a user without a password, with sudo privilages, without password requirement when sudo command is used.
  - Creates an SSH key for the user.
- `new-server-user-scripts.sh`:
  - Disables root login and login with password,
  - Configures memory swap,
  - Sets up the server time zone, configure time sync,
  - Installs and configures:
    - Automatic system security updates,
    - Firewall: UFW,
    - SSH brute force protection: Fail2ban,
    - Anti-malware and their cron jobs:
      - ClamAV,
      - Rootkit hunter,
      - Lynis,
    - Docker,
    - CapRover.

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

### `repoacp`

Combines git

- Adds all changes to stage,
- Commits with customizable message,
- Pushes.

## show-hide-mounted-drives-on-ubuntu-desktop

Scripts to shows and hide the mounted drives on Ubuntu Desktop.
