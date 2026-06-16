@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ================================================
echo  Tailwind CSS をビルドしています...
echo ================================================
tools\tailwindcss.exe -i src\input.css -o css\tailwind.css --minify
echo.
echo ================================================
echo  完了しました！ css\tailwind.css を更新しました。
echo  ※HTMLを編集したら、このファイルを実行してください。
echo ================================================
pause
