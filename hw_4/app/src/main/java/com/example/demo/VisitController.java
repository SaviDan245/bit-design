package com.example.demo;

import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class VisitController {

    private final JdbcTemplate jdbcTemplate;

    public VisitController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/visits")
    public Map<String, Integer> visits() {
        jdbcTemplate.update("insert into visits default values");
        Integer count = jdbcTemplate.queryForObject("select count(*) from visits", Integer.class);
        return Map.of("visits", count);
    }
}
