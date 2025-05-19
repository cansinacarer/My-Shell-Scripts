@echo off
setlocal

@REM Initialize the repo, add everything to stage
git init -b main
git add .

REM Prompt the user for a commit message
set /p commitMessage="Enter commit message (default: first commit): "

REM Check if the user provided a message, otherwise use the default
if "%commitMessage%"=="" set commitMessage=first commit

REM Commit
git commit -m "%commitMessage%"

REM Get the current directory name
for %%I in ("%cd%") do set "repo_name=%%~nI"

REM Create the GitHub repository, add it as remote, then push
gh repo create %repo_name% --private --source=. --remote=origin --push

endlocal