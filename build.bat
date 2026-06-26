@echo off
cd /d "%~dp0"
echo ================================================
echo  Building Tailwind CSS...
echo ================================================
tools\tailwindcss.exe -i src\input.css -o css\tailwind.css --minify
echo.
echo ================================================
echo  Done! css\tailwind.css has been updated.
echo  Run this file again after editing any HTML file.
echo ================================================
pause
