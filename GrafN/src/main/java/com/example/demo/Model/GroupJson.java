package com.example.demo.Model;

import java.util.List;

public class GroupJson {
    private String groupName;
    private String location;
    private List<Friend> memberList;
    private int numCommonFriends;

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

//    public List<Friend> getMemberList() {
//        return memberList;
//    }

    public String getLocation() {
        return location;
    }

    public void setMemberList(List<Friend> memberList) {
        this.memberList = memberList;
    }

    public int getNumCommonFriends() {
        return numCommonFriends;
    }

    public void setNumCommonFriends(int numCommonFriends) {
        this.numCommonFriends = numCommonFriends;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
