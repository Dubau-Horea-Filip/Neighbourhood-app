package com.example.demo.Model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.List;

@Node
public class Group {

    @Id
    @GeneratedValue
    private Long id;

    @JsonIgnore
    @Relationship(type = "GROUP", direction = Relationship.Direction.INCOMING)
    private List<Friend> memberList;

    private String location;

    @Override
    public String toString() {
        return "Group{" +
                "groupId=" + id +
                ", Location='" + location + '\'' +
                ", groupName='" + groupName + '\'' +
                '}';
    }



    public Long getId() {
        return id;
    }

    public List<Friend> getMemberList() {
        return memberList;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getLocation() {
        return location;
    }

    public String getGroupName() {
        return groupName;
    }

    private String groupName;



}
