@echo off
echo === DEPLOIEMENT DOCKER ===
echo.

echo 1. Nettoyage...
docker rm -f todo-container 2>nul

echo 2. Construction du JAR...
call mvn clean package -DskipTests

echo 3. Construction de l'image Docker...
docker build -t todo-api .

echo 4. Déploiement sur port 8087:8088...
docker run -d -p 8087:8088 --name todo-container todo-api
timeout /t 7

echo 5. Tests...
echo --- API Todo ---
curl http://localhost:8087/api/tasks
echo.
echo --- Actuator Health ---
curl http://localhost:8087/actuator/health
echo.
echo --- Logs ---
docker logs --tail 3 todo-container

echo.
echo ✅ DÉPLOIEMENT TERMINÉ
echo URL: http://localhost:8087/api/tasks
pause