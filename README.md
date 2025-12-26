# DevOps Project - Todo API

## Description
Spring Boot REST API for DevOps project with Docker containerization.

## Technologies
- Java 21
- Spring Boot 3.2.5
- Docker
- Maven

## API Endpoints
- GET `/api/tasks` - List all tasks
- GET `/api/tasks/{id}` - Get task by ID
- POST `/api/tasks` - Create new task
- DELETE `/api/tasks/{id}` - Delete task

## Docker Commands
```bash
# Build
docker build -t todo-api .

# Run
docker run -d -p 8087:8088 --name todo-container todo-api

# Test
curl http://localhost:8087/api/tasks