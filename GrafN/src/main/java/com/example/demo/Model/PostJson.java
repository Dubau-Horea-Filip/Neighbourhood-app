package com.example.demo.Model;

public class PostJson {
    private String email;
    private String group;
    private String post;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    private String id;



    public PostJson() {
    }

    public PostJson(String email, String group, String post,  String getid) {
        this.email = email;
        this.group = group;
        this.post = post;
        this.id = getid;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }
}
