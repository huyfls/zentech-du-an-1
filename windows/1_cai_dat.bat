@echo off
REM ZenTech - cai dat lan dau tren Windows: kiem tra XAMPP, nap database, tai anh san pham Apple
setlocal
cd /d "%~dp0.."
set "XAMPP=C:\xampp"
set "PHP=%XAMPP%\php\php.exe"
set "MYSQL=%XAMPP%\mysql\bin\mysql.exe"
set "IMG_URL=https://github.com/huyfls/zentech-du-an-1/releases/download/anh-apple-v1/apple_images.zip"

echo ================================================
echo   ZenTech - Cai dat lan dau
echo ================================================
if not exist "%PHP%" goto noxampp
if not exist "%MYSQL%" goto noxampp

echo [1/4] Kiem tra PHP va cac extension can thiet...
"%PHP%" -v | findstr /b "PHP"
for %%e in (pdo_mysql mbstring fileinfo) do (
  "%PHP%" -m | findstr /i /x "%%e" >nul || echo    [CANH BAO] Thieu extension %%e: mo %XAMPP%\php\php.ini, bo dau ; truoc dong extension=%%e
)

echo [2/4] Kiem tra MySQL dang chay...
"%MYSQL%" -uroot -e "SELECT 1" >nul 2>&1
if errorlevel 1 goto nomysql

echo [3/4] Tao database zentech_db va nap du lieu (GHI DE neu da co)...
"%MYSQL%" -uroot -e "CREATE DATABASE IF NOT EXISTS zentech_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
"%MYSQL%" -uroot --default-character-set=utf8mb4 zentech_db < "database\zentech_full_dump.sql"
if errorlevel 1 goto dberror
echo    Xong.

echo [4/4] Anh san pham Apple (khoang 1,6GB)...
if exist "public\uploads\products\apple\*.jpg" (
  echo    Da co anh, bo qua.
  goto done
)
echo    Dang tai, co the mat vai phut tuy toc do mang...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol='Tls12'; $f=Join-Path $env:TEMP 'zentech_apple_images.zip'; Invoke-WebRequest -Uri '%IMG_URL%' -OutFile $f; Expand-Archive -Force -Path $f -DestinationPath 'public\uploads\products'; Remove-Item $f"
if errorlevel 1 (
  echo    [CANH BAO] Khong tai duoc anh. Tai tay: %IMG_URL%
  echo    roi giai nen vao public\uploads\products\  ^(se co thu muc apple^)
)

:done
echo.
echo HOAN TAT. Chay file windows\2_chay_web.bat de mo website.
pause
exit /b 0

:noxampp
echo [LOI] Khong tim thay XAMPP tai %XAMPP%.
echo Cai XAMPP ban PHP 8.2 tai https://www.apachefriends.org vao C:\xampp,
echo hoac sua dong "set XAMPP=..." o dau file nay cho dung thu muc da cai.
pause
exit /b 1

:nomysql
echo [LOI] MySQL chua chay. Mo XAMPP Control Panel, bam Start o dong MySQL, roi chay lai file nay.
pause
exit /b 1

:dberror
echo [LOI] Nap database that bai. Xem thong bao loi o tren.
pause
exit /b 1
