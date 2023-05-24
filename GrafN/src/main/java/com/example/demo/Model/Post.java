package com.example.demo.Model;

import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.List;

@Node
public class Post {

    @Id
    @GeneratedValue
    private Long id;

    @Relationship(type = "CREATED_BY", direction = Relationship.Direction.OUTGOING)
    private Friend user;

    @Relationship(type = "POSTED_IN", direction = Relationship.Direction.OUTGOING)
    private Group group;
    private String post;

    public Group getGroup() {
        return group;
    }

    public void setGroup(Group group) {
        this.group = group;
    }



    @Relationship(type = "COMMENT", direction = Relationship.Direction.INCOMING)
    private List<Comment> comments;

    public Friend getUser() {
        return user;
    }

    public void setUser(Friend user) {
        this.user = user;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
}
