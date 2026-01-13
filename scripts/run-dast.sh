#!/bin/bash
# Script de scan DAST avancé

set -e

echo "🚀 Starting DAST Security Scan"
echo "================================"

API_URL="http://localhost:8088"
ZAP_PORT="8090"
SCAN_DURATION="300"  # 5 minutes

# 1. Démarrer ZAP en mode daemon
echo "1. Starting OWASP ZAP..."
docker run -d \
  -p $ZAP_PORT:$ZAP_PORT \
  -u zap \
  --name zap \
  owasp/zap2docker-stable zap.sh \
  -daemon \
  -port $ZAP_PORT \
  -host 0.0.0.0 \
  -config api.disablekey=true

sleep 10

# 2. Scanner l'API
echo "2. Scanning API at $API_URL..."
docker exec zap zap-cli --port $ZAP_PORT \
  quick-scan \
  --self-contained \
  --start-options="-config scanner.delayInMs=500" \
  $API_URL

# 3. Exporter le rapport
echo "3. Generating security reports..."
docker exec zap zap-cli --port $ZAP_PORT \
  report -o /zap/report.html -f html

docker exec zap zap-cli --port $ZAP_PORT \
  report -o /zap/report.json -f json

# 4. Copier les rapports
docker cp zap:/zap/report.html ./zap-report.html
docker cp zap:/zap/report.json ./zap-report.json

# 5. Analyser les résultats
echo "4. Analyzing results..."
CRITICAL=$(grep -c "High" zap-report.html || echo "0")
HIGH=$(grep -c "Medium" zap-report.html || echo "0")

echo "================================="
echo "📊 SECURITY SCAN RESULTS"
echo "================================="
echo "🔴 Critical issues: $CRITICAL"
echo "🟠 High issues: $HIGH"
echo "📁 Reports: zap-report.html, zap-report.json"
echo "================================="

if [ "$CRITICAL" -gt "0" ]; then
  echo "❌ CRITICAL VULNERABILITIES FOUND!"
  exit 1
fi

echo "✅ DAST scan completed successfully"