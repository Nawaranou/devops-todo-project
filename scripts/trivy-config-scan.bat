@echo off
echo 🔍 Trivy Configuration Scan
echo ============================

REM 1. Installer Trivy si nécessaire
where trivy >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Trivy...
    powershell -Command "iwr -useb https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.ps1 | iex"
)

REM 2. Scan du Dockerfile
echo 1. Scanning Dockerfile...
trivy config --severity HIGH,CRITICAL .

REM 3. Scan des fichiers Kubernetes
echo 2. Scanning Kubernetes manifests...
if exist kubernetes\*.yaml (
    for %%f in (kubernetes\*.yaml) do (
        echo Scanning %%f...
        trivy config --severity HIGH,CRITICAL "%%f"
    )
)

REM 4. Scan des configurations
echo 3. Scanning application configs...
if exist src\main\resources\ (
    trivy config --severity HIGH,CRITICAL src\main\resources\
)

echo ✅ Trivy config scan completed