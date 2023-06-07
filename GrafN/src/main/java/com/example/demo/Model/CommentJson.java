package com.example.demo.Model;

public class CommentJson {

    private String email;
    private String postId;
    private String comment;

    private String id;

    public CommentJson() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPostId() {
        return postId;
    }

    public void setPostId(String postId) {
        this.postId = postId;
    }

    public CommentJson(String email, String group, String comment) {
        this.email = email;
        this.postId = group;
        this.comment = comment;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }



    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
