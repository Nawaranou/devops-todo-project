package com.devops.todo.repository;

import com.devops.todo.model.Task;
import org.springframework.cloud.sleuth.annotation.NewSpan;
import org.springframework.cloud.sleuth.annotation.SpanTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    // ⭐ Les annotations Sleuth fonctionneront automatiquement avec Spring Data JPA

    @NewSpan("findAllTasks")
    @Override
    List<Task> findAll();

    @NewSpan("findTaskById")
    @Override
    Optional<Task> findById(@SpanTag("task.id") Long id);

    @NewSpan("saveTask")
    @Override
    <S extends Task> S save(@SpanTag("task") S entity);

    @NewSpan("deleteTask")
    @Transactional
    @Override
    void deleteById(@SpanTag("task.id") Long id);

    @NewSpan("existsTask")
    @Override
    boolean existsById(@SpanTag("task.id") Long id);
}