package com.example.demo.Model;

import java.util.List;

public class FriendJson {
    private String name;
    private String email;

    private String password;

    private List<String> frinds_emails;
    private List<String> groupsName;

    public List<String> getGroupsName() {
        return groupsName;
    }

    public void setGroupsName(List<String> groupsName) {
        this.groupsName = groupsName;
    }

    public List<String> getFrinds_emails() {
        return frinds_emails;
    }

    public void setFrinds_emails(List<String> frinds_emails) {
        this.frinds_emails = frinds_emails;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    public FriendJson()
    {}



    public FriendJson(String name, String email) {
        this.name = name;
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Friend{" +
                "name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
