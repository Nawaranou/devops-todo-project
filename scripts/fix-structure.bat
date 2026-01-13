@echo off
echo ====================================
echo    FIXING PROJECT STRUCTURE
echo ====================================

echo 1. Creating correct directory structure...
mkdir src\main\java\com\devops\todo 2>nul
mkdir src\main\java\com\devops\todo\controller 2>nul
mkdir src\main\java\com\devops\todo\model 2>nul
mkdir src\main\java\com\devops\todo\repository 2>nul

echo 2. Finding and fixing Java files...
echo.

REM Trouver et corriger TodoApplication.java
for /r src\main\java %%f in (TodoApplication.java) do (
    echo Fixing %%f
    (
        echo package com.devops.todo;
        echo.
        echo import org.springframework.boot.SpringApplication;
        echo import org.springframework.boot.autoconfigure.SpringBootApplication;
        echo.
        echo @SpringBootApplication^(scanBasePackages = "com.devops.todo"^)
        echo public class TodoApplication {
        echo     public static void main^(String[] args^) {
        echo         SpringApplication.run^(TodoApplication.class, args^);
        echo     }
        echo }
    ) > src\main\java\com\devops\todo\TodoApplication.java
    goto :foundApp
)
:foundApp

REM Corriger TaskController.java
echo Fixing TaskController.java...
(
    echo package com.devops.todo.controller;
    echo.
    echo import com.devops.todo.model.Task;
    echo import com.devops.todo.repository.TaskRepository;
    echo import org.springframework.beans.factory.annotation.Autowired;
    echo import org.springframework.http.ResponseEntity;
    echo import org.springframework.web.bind.annotation.*;
    echo import java.util.List;
    echo.
    echo @RestController
    echo @RequestMapping^("/api/tasks"^)
    echo public class TaskController {
    echo.
    echo     @Autowired
    echo     private TaskRepository taskRepository;
    echo.
    echo     @GetMapping^("/ping"^)
    echo     public String ping^(^) {
    echo         return "✅ TaskController is working!";
    echo     }
    echo.
    echo     @GetMapping
    echo     public List^<Task^> getAllTasks^(^) {
    echo         return taskRepository.findAll^(^);
    echo     }
    echo.
    echo     @GetMapping^("/{id}"^)
    echo     public ResponseEntity^<Task^> getTaskById^(@PathVariable Long id^) {
    echo         Task task = taskRepository.findById^(id^);
    echo         if ^(task == null^) {
    echo             return ResponseEntity.notFound^(^).build^(^);
    echo         }
    echo         return ResponseEntity.ok^(task^);
    echo     }
    echo.
    echo     @PostMapping
    echo     public Task createTask^(@RequestBody Task task^) {
    echo         return taskRepository.save^(task^);
    echo     }
    echo.
    echo     @DeleteMapping^("/{id}"^)
    echo     public ResponseEntity^<Void^> deleteTask^(@PathVariable Long id^) {
    echo         if ^(taskRepository.findById^(id^) == null^) {
    echo             return ResponseEntity.notFound^(^).build^(^);
    echo         }
    echo         taskRepository.deleteById^(id^);
    echo         return ResponseEntity.noContent^(^).build^(^);
    echo     }
    echo }
) > src\main\java\com\devops\todo\controller\TaskController.java

echo 3. Building project...
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ❌ Build failed! Check Maven errors.
    pause
    exit /b 1
)

echo ✅ Project structure fixed successfully!
echo ====================================
pause