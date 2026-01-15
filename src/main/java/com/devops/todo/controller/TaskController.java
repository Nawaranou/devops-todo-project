package com.devops.todo.controller;

import com.devops.todo.model.Task;
import com.devops.todo.repository.TaskRepository;
import com.devops.todo.config.MetricsConfig;
import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private Counter taskCreationCounter;

    @Autowired
    private Counter taskDeletionCounter;

    @Autowired
    private Timer taskProcessingTimer;

    @PostConstruct
    public void init() {
        System.out.println("✅ TaskController initialized!");
        // ⭐ Initialiser avec quelques données si nécessaire
        if (taskRepository.count() == 0) {
            taskRepository.save(new Task(null, "Apprendre DevOps", "Description 1", false));
            taskRepository.save(new Task(null, "Faire le projet", "Description 2", false));
        }
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return taskProcessingTimer.record(() -> taskRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskById(@PathVariable Long id) {
        return taskProcessingTimer.record(() -> {
            Optional<Task> task = taskRepository.findById(id);
            return task.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        });
    }

    @PostMapping
    public Task createTask(@RequestBody Task task) {
        Task savedTask = taskProcessingTimer.record(() -> taskRepository.save(task));
        taskCreationCounter.increment();
        return savedTask;
    }

    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @RequestBody Task updatedTask) {
        return taskProcessingTimer.record(() -> {
            Optional<Task> existingTaskOpt = taskRepository.findById(id);
            if (existingTaskOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Task existingTask = existingTaskOpt.get();
            existingTask.setTitle(updatedTask.getTitle());
            existingTask.setCompleted(updatedTask.isCompleted());
            if (updatedTask.getDescription() != null) {
                existingTask.setDescription(updatedTask.getDescription());
            }

            Task savedTask = taskRepository.save(existingTask);
            return ResponseEntity.ok(savedTask);
        });
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        return taskProcessingTimer.record(() -> {
            if (!taskRepository.existsById(id)) {
                return ResponseEntity.notFound().build();
            }
            taskRepository.deleteById(id);
            taskDeletionCounter.increment();
            return ResponseEntity.noContent().build();
        });
    }
}