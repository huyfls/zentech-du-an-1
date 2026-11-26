@echo off
REM ZenTech - chay website tai http://localhost:8001 (dong cua so nay de tat)
setlocal
cd /d "%~dp0.."
set "XAMPP=C:\xampp"
set "PHP=%XAMPP%\php\php.exe"
set "MYSQL=%XAMPP%\mysql\bin\mysql.exe"
set "PORT=8001"

if not exist "%PHP%" (
  echo [LOI] Khong tim thay %PHP%. Sua dong "set XAMPP=..." trong file nay.
  pause
  exit /b 1
)
"%MYSQL%" -uroot -e "USE zentech_db" >nul 2>&1
if errorlevel 1 (
  echo [LOI] MySQL chua chay hoac chua co database zentech_db.
  echo Mo XAMPP Control Panel - Start MySQL. Neu chua cai dat, chay windows\1_cai_dat.bat truoc.
  pause
  exit /b 1
)

echo ================================================
echo   ZenTech dang chay tai http://localhost:%PORT%
echo   Trang quan tri:      http://localhost:%PORT%/admin
echo   Dong cua so nay de tat website.
echo ================================================
start "" cmd /c "timeout /t 2 >nul & start http://localhost:%PORT%"
"%PHP%" -S localhost:%PORT% -t public
pause
