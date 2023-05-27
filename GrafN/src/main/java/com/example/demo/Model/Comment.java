package com.example.demo.Model;


import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.List;

@Node
public class Comment {

    @Id
    @GeneratedValue
    private Long id;

  private String  comment;
  @Relationship(type = "COMMENT_BY", direction = Relationship.Direction.OUTGOING)
  private Friend user;

  @Relationship(type = "COMMENT_IN", direction = Relationship.Direction.OUTGOING)
  private Post post;

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Friend getUser() {
        return user;
    }

    public void setUser(Friend user) {
        this.user = user;
    }

    public Post getPost() {
        return post;
    }

    public void setPost(Post post) {
        this.post = post;
    }
}
