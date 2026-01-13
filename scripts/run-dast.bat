@echo off
echo ========================================
echo    DAST SECURITY SCAN - WINDOWS
echo ========================================

REM Vérifier que Docker est démarré
echo 1. Checking Docker...
docker ps >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: Docker Desktop is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Télécharger l'image ZAP
echo 2. Downloading ZAP Docker image...
docker pull ghcr.io/zaproxy/zaproxy:stable
if %errorlevel% neq 0 (
    echo ❌ Failed to download ZAP image
    pause
    exit /b 1
)

REM Vérifier que l'API est en cours d'exécution
echo 3. Checking if API is running...
curl -s http://localhost:8088/actuator/health >nul
if %errorlevel% neq 0 (
    echo ⚠️  API is not running on port 8088
    echo Starting API for testing...

    REM Construire et démarrer l'API
    cd ..
    call mvn clean package -DskipTests
    docker build -t todo-api-scan .
    docker run -d -p 8088:8088 --name todo-api-scan todo-api-scan
    cd scripts
    timeout /t 25 /nobreak

    REM Vérifier que l'API est prête
    echo Waiting for API to be ready...
    :waitloop
    curl -s http://localhost:8088/actuator/health >nul
    if %errorlevel% neq 0 (
        timeout /t 5 /nobreak
        goto waitloop
    )
)

echo ✅ API is running

REM Scanner l'API avec ZAP
echo 4. Running ZAP security scan...
echo This may take 2-3 minutes...
docker run --rm ^
  -v %CD%\..\reports:/zap/wrk ^
  -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py ^
  -t http://host.docker.internal:8088 ^
  -r zap-report.html ^
  -x zap-report.xml ^
  -J zap-report.json

if %errorlevel% neq 0 (
    echo ⚠️  ZAP scan completed with warnings
) else (
    echo ✅ ZAP scan completed successfully
)

REM Nettoyer
echo 5. Cleaning up...
docker stop todo-api-scan >nul 2>nul
docker rm todo-api-scan >nul 2>nul

echo ========================================
echo 📊 SCAN RESULTS:
if exist ..\reports\zap-report.html (
    echo ✅ Reports generated in 'reports' folder:
    echo    - zap-report.html (HTML report)
    echo    - zap-report.xml (XML report)
    echo    - zap-report.json (JSON report)
    echo.
    echo 📍 Open zap-report.html in your browser
) else (
    echo ❌ No reports generated
    echo Check Docker logs for errors
)
echo ========================================
pause