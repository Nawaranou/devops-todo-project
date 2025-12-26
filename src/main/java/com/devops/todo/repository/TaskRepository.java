package com.devops.todo.repository;



import com.devops.todo.model.Task;
import org.springframework.stereotype.Repository;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Repository
public class TaskRepository {
    private final Map<Long, Task> tasks = new HashMap<>();
    private final AtomicLong counter = new AtomicLong(1);

    public TaskRepository() {
        save(new Task(1L, "Apprendre DevOps", false));
        save(new Task(2L, "Faire le projet", false));
    }

    public List<Task> findAll() {
        return new ArrayList<>(tasks.values());
    }

    public Task findById(Long id) {
        return tasks.get(id);
    }

    public Task save(Task task) {
        if (task.getId() == null) {
            task.setId(counter.getAndIncrement());
        }
        tasks.put(task.getId(), task);
        return task;
    }

    public void deleteById(Long id) {
        tasks.remove(id);
    }
}