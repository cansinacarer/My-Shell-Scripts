@echo off
setlocal

@REM Add everything to stage
git add .

REM Prompt the user for a commit message
set /p commitMessage="Enter commit message (default: first commit): "

REM Check if the user provided a message, otherwise use the default
if "%commitMessage%"=="" set commitMessage=first commit

REM Commit
git commit -m "%commitMessage%"

REM Push
git push

endlocal