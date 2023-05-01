package com.example.demo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Node
public class Friend {


    @Id @GeneratedValue
    private Long id;
    private String name;
    private String email;

    @JsonIgnore
    @Relationship(type = "FRIEND", direction = Relationship.Direction.OUTGOING)
    private List<Friend> friends;




    public String getEmail() {
        return email;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFriends(List<Friend> friends) {
        this.friends = friends;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Friend{");
        sb.append("id=").append(id);
        sb.append(", name='").append(name).append('\'');
        sb.append(", email='").append(email).append('\'');
        sb.append(", friends=[");
        for (int i = 0; i < friends.size(); i++) {
            Friend friend = friends.get(i);
            sb.append(friend.getId());
            if (i < friends.size() - 1) {
                sb.append(", ");
            }
        }
        sb.append("]");
        sb.append('}');
        return sb.toString();
    }

    public List<Friend> getFriends() {
        return friends;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }





}
