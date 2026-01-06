@echo off
setlocal
cd /d %~dp0\..
echo [1/3] Generating index.xml...
python tools\generate_index.py
if errorlevel 1 goto :err
echo [2/3] Validating index.xml...
python tools\validate_reapack_index.py
if errorlevel 1 goto :err
echo [3/3] Done. Now commit and push:
echo   git add -A
echo   git commit -m "Release: update index"
echo   git push origin main
echo Then verify in browser:
echo   https://raw.githubusercontent.com/IfeelLikeSnow/IFLS_Toolbar_Suite/main/index.xml
exit /b 0
:err
echo ERROR: release step failed.
exit /b 1
