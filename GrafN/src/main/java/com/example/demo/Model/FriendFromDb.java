package com.example.demo.Model;

import java.util.List;

public class FriendFromDb {
    private final List<Friend> friends;

    private String name;
    private String email;

    public FriendFromDb(String name, String email, List<Friend> friends) {
        this.name = name;
        this.email = email;
        this.friends = friends;

    }

    public String getName() {
        return name;
    }

    public List<Friend> getFriends() {
        return friends;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    @Override
    public String toString() {
        return "FriendFromDb{" +
                "friends=" + friends +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}

