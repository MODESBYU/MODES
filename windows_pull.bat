@echo off
echo Running Git commands...

set "repository_path=\"%~dp0""

"C:\Program Files\Git\bin\bash.exe" -c "cd %repository_path% && git pull origin main"

echo Successfully pulled the updated version

pause
