package com.devops.todo.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.UUID;

@Component
public class LoggingInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(LoggingInterceptor.class);
    private static final String REQUEST_ID = "requestId";
    private static final String METHOD = "method";
    private static final String PATH = "path";

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {
        // Générer un ID unique pour la requête
        String requestId = UUID.randomUUID().toString();
        MDC.put(REQUEST_ID, requestId);
        MDC.put(METHOD, request.getMethod());
        MDC.put(PATH, request.getRequestURI());

        // Log de début de requête
        logger.info("Request started",
                kv("status", "started"),
                kv("query", request.getQueryString()),
                kv("remoteAddr", request.getRemoteAddr())
        );

        request.setAttribute("startTime", System.currentTimeMillis());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) {
        Long startTime = (Long) request.getAttribute("startTime");
        long duration = System.currentTimeMillis() - startTime;

        // Log de fin de requête
        logger.info("Request completed",
                kv("status", "completed"),
                kv("durationMs", duration),
                kv("statusCode", response.getStatus()),
                kv("exception", ex != null ? ex.getClass().getSimpleName() : "none")
        );

        // Nettoyer le MDC
        MDC.clear();
    }

    // Méthode utilitaire pour les key-value logs
    private Object kv(String key, Object value) {
        return new Object() {
            @Override
            public String toString() {
                return key + "=" + (value != null ? value.toString() : "null");
            }
        };
    }
}