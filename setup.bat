@echo off
REM ==============================================================================
REM Adobe Premiere Pro MCP Connector - One-Click Launcher for Windows
REM ==============================================================================
echo Launching Premiere Pro MCP Setup...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
echo.
pause
