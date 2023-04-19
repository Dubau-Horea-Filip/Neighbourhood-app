package com.example.demo;

import org.springframework.data.neo4j.repository.Neo4jRepository;

public interface RealeseRepo extends Neo4jRepository<Release, Long> { }
