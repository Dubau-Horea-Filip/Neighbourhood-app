package com.example.demo.Repos;

import com.example.demo.Model.User;
import org.springframework.data.neo4j.repository.Neo4jRepository;

public interface UserRepo extends Neo4jRepository<User,Long> {
}
