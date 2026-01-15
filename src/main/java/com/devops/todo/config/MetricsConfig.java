package com.devops.todo.config;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
public class MetricsConfig {

    @Bean
    public Counter taskCreationCounter(MeterRegistry registry) {
        return Counter.builder("todo.tasks.created")
                .description("Total number of tasks created")
                .tag("application", "todo-api")
                .register(registry);
    }

    @Bean
    public Counter taskDeletionCounter(MeterRegistry registry) {
        return Counter.builder("todo.tasks.deleted")
                .description("Total number of tasks deleted")
                .tag("application", "todo-api")
                .register(registry);
    }

    @Bean
    public Timer taskProcessingTimer(MeterRegistry registry) {
        return Timer.builder("todo.tasks.processing.time")
                .description("Time taken to process task operations")
                .publishPercentiles(0.5, 0.95, 0.99)
                .publishPercentileHistogram()
                .register(registry);
    }
}