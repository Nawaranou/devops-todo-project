@echo off
echo ================================
echo    QUICK DAST SCAN
echo ================================

echo 1. Checking if API is running...
curl -s http://localhost:8087/actuator/health >nul
if %errorlevel% neq 0 (
    echo ERROR: API is not running on port 8087
    echo Please start your API first with:
    echo   docker run -d -p 8087:8088 --name todo-api todo-api
    pause
    exit /b 1
)

echo 2. Creating reports directory...
mkdir ..\reports 2>nul

echo 3. Running ZAP baseline scan...
echo This will take 2-3 minutes...
docker run --rm ^
  -v %CD%\..\reports:/zap/wrk ^
  -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py ^
  -t http://host.docker.internal:8087 ^
  -r dast-report.html

echo.
if exist ..\reports\dast-report.html (
    echo ✅ DAST scan completed successfully!
    echo 📁 Report saved to: ..\reports\dast-report.html
    echo.
    echo 📊 Opening report...
    start ..\reports\dast-report.html
) else (
    echo ❌ DAST scan failed to generate report
    echo Check Docker logs for errors
)

echo ================================
pause