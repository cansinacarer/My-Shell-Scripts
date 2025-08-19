@echo off
setlocal

@REM Read the repo name passed as an argument
set "repo_name=%~1"
if "%repo_name%"=="" (
    echo No repository name provided. Please provide a name as an argument.
    exit /b 1
)

@REM Create a folder with the repo name
mkdir "%repo_name%"
if errorlevel 1 (
    echo Failed to create directory "%repo_name%". It may already exist.
    exit /b 1
)

@REM Change to the new directory
cd "%repo_name%" || exit /b 1

@REM Initialize an empty Git repository
git init -b main
if errorlevel 1 (
    echo Failed to initialize Git repository in "%repo_name%".
    exit /b 1
)
git add .

REM Commit
git commit --allow-empty -m "first commit"
if errorlevel 1 (
    echo Failed to commit changes. Please check your Git configuration.
    exit /b 1
)

REM Get the current directory name
for %%I in ("%cd%") do set "repo_name=%%~nI"

REM Create the GitHub repository, add it as remote, then push
gh repo create %repo_name% --private --source=. --remote=origin --push
if errorlevel 1 (
    echo Failed to create GitHub repository. Please ensure you are authenticated with GitHub CLI.
    exit /b 1
)

@REM Open the repository in VS Code
code .
if errorlevel 1 (
    echo Failed to open the repository in VS Code. Please ensure it is installed and in your PATH.
    exit /b 1
)

endlocal