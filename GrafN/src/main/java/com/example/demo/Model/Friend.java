package com.example.demo.Model;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.List;

@Node
public class Friend {


    @Id @GeneratedValue
    private Long id;
    private String name;
    private String email;
    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @JsonIgnore
    @Relationship(type = "FRIEND", direction = Relationship.Direction.OUTGOING)
    private List<Friend> friends;

    @JsonIgnore
    @Relationship(type = "GROUP", direction = Relationship.Direction.OUTGOING)
    private List<Group> groupList;


    public List<Group> getGroupList() {
        return groupList;
    }

    public void setGroupList(List<Group> groupList) {
        this.groupList = groupList;
    }

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

    public List<String> getFriendEmails() {
        List<String> friendEmails = new ArrayList<>();
        if (friends != null) {
            for (Friend friend : friends) {
                friendEmails.add(friend.getEmail());
            }
        }
        return friendEmails;
    }

    public List<String> getGroupNames() {
        List<String> groupNames = new ArrayList<>();
        if (groupList != null) {
            for (Group group : groupList) {
                groupNames.add(group.getGroupName());
            }
        }
        return groupNames;
    }




    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Friend{");
        sb.append("id=").append(id);
        sb.append(", name='").append(name).append('\'');
        sb.append(", email='").append(email).append('\'');
        sb.append(", friends=[");

        if (friends != null) {
            for (int i = 0; i < friends.size(); i++) {
                Friend friend = friends.get(i);
                sb.append(friend.getId());
                if (i < friends.size() - 1) {
                    sb.append(", ");
                }
            }
        }

        sb.append("], groups=[");
        if (groupList != null) {
            for (int i = 0; i < groupList.size(); i++) {
                Group group = groupList.get(i);
                sb.append(group.getId());
                if (i < groupList.size() - 1) {
                    sb.append(", ");
                }
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
