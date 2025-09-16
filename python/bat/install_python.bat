@echo off
title Python Auto Installer
echo ===================================
echo   Windows Python Auto Installer
echo ===================================
echo.

:: Download the latest Python installer (64-bit)
echo [Action] Downloading the latest Python ...
set DOWNLOAD_URL=https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe
set INSTALLER=python-installer.exe

powershell -Command "Invoke-WebRequest -Uri %DOWNLOAD_URL% -OutFile %INSTALLER%"

if not exist %INSTALLER% (
    echo [Error] Failed to download Python, please check network connection or download manually.
    pause
    exit /b
)

:: Install Python silently, automatically add to PATH
echo [Action] Installing Python ...
%INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

if %errorlevel% neq 0 (
    echo [Error] Python installation failed.
    pause
    exit /b
)

:: Delete installer
del %INSTALLER%
echo [Info] Python installation completed.
echo.

:: Refresh environment variables
setx PATH "%PATH%"
echo [Info] PATH updated.
echo.

:: Check Python version
echo [Info] Python version:
python --version
if %errorlevel% neq 0 (
    echo [Error] Python is not installed correctly, please run this script again.
    pause
    exit /b
)
echo.

:: Check pip and upgrade
echo [Action] Upgrading pip ...
python -m ensurepip
python -m pip install --upgrade pip
echo.

:: Create virtual environment
if not exist myenv (
    echo [Action] Creating virtual environment myenv ...
    python -m venv myenv
) else (
    echo [Info] Virtual environment myenv already exists.
)
echo.

:: Activate virtual environment
echo [Action] Activating virtual environment myenv ...
call myenv\Scripts\activate.bat

:: Test Python execution
echo [Test] Running Hello, Python! ...
python -c "print('Hello, Python!')"
echo.

echo ===================================
echo   Python Installation and Configuration Complete
echo ===================================
pause
