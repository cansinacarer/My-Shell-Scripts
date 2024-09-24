# My Windows Batch Scripts

My primitive scripts for bundling multiple Windows commands into one.

## Usage
Add this repo to path, then you can call any of the scripts below from any directory.

You must have GitHub CLI and git installed and configured before using these scripts.

### `repomake`
1. Initializes a repository,
2. Adds everything in the current directory to stage,
3. Commits everything stages with the message "first commit" (customizable),
4. Creates a Github repo using the name of the current directory as the repo name, adds it as remote,
5. Pushes everything to the newly created remote repo.

### `repoacp`
Combines git
- Add all changes to stage,
- Commit with customizable message,
- Push