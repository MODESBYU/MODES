@echo off
echo Running Git commands...

set "repository_path=\"%~dp0""

set /p commit_message=Enter the commit message: 

"C:\Program Files\Git\bin\bash.exe" -c "cd %repository_path% && git add ."

"C:\Program Files\Git\bin\bash.exe" -c "cd %repository_path% && git commit -m '%commit_message%'"

"C:\Program Files\Git\bin\bash.exe" -c "cd %repository_path% && git push origin main"

pause
