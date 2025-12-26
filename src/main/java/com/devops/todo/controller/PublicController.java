package com.devops.todo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/public")
public class PublicController {

    @GetMapping("/health")
    public Map<String, Object> publicHealth() {
        return Map.of(
                "status", "UP",
                "service", "Todo API",
                "timestamp", LocalDateTime.now().toString(),
                "message", "Public endpoint accessible without authentication"
        );
    }

    @GetMapping("/info")
    public Map<String, String> info() {
        return Map.of(
                "name", "Todo DevOps Project",
                "version", "1.0.0",
                "description", "Spring Boot API with DevOps practices"
        );
    }
}