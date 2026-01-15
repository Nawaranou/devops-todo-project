package com.devops.todo.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity  // ⭐ AJOUTER cette annotation
public class Task {

    @Id  // ⭐ AJOUTER cette annotation
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // ⭐ AJOUTER cette annotation
    private Long id;

    private String title;
    private boolean completed;

    // ⭐ AJOUTER le champ description si nécessaire
    private String description;

    public Task() {}

    public Task(Long id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    // ⭐ AJOUTER ce constructeur
    public Task(Long id, String title, String description, boolean completed) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.completed = completed;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }

    // ⭐ AJOUTER getter/setter pour description
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}