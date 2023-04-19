package com.example.demo;

import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.time.LocalTime;
import java.util.List;

@Node
public class Song {

    @Id @GeneratedValue
    private Long id;
    private String name;
    private LocalTime length;

    @Relationship(type = "APPEARS_ON", direction = Relationship.Direction.OUTGOING)
    private List<AppearsOn> releses;



    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }



    public LocalTime getLength() {
        return length;
    }



    public List<AppearsOn> getReleses() {
        return releses;
    }

    public void setReleses(List<AppearsOn> releses) {
        this.releses = releses;
    }

}
