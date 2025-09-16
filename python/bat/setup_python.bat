@echo off
title Python Setup Script
echo ================================
echo   Windows Python Setup Script
echo ================================
echo.

:: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [Error] Python not detected, please download and install from https://www.python.org/downloads/windows/.
    pause
    exit /b
)

:: Display Python version
echo [Info] Python version:
python --version
echo.

:: Check if pip is available
echo [Info] pip version:
pip --version
if %errorlevel% neq 0 (
    echo [Error] pip not detected, please ensure "Add to PATH" was checked during installation.
    pause
    exit /b
)
echo.

:: Upgrade pip
echo [Action] Upgrading pip ...
python -m pip install --upgrade pip
echo.

:: Create virtual environment myenv
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

:: Run Hello Python test
echo [Test] Running Hello, Python! ...
python -c "print('Hello, Python!')"
echo.

echo ================================
echo   Python environment setup complete
echo ================================
pause
