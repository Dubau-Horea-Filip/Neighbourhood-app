package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/friends")
public class FriendController {

    private final FrindRepo friendRepository;

    @Autowired
    public FriendController(FrindRepo friendRepository) {
        this.friendRepository = friendRepository;
    }

    @GetMapping
    public List<Friend> getAllFriends() {
        List<Friend> list = friendRepository.findAll();
        return list;
    }


    @PostMapping("/add")
    public ResponseEntity<Friend> addFriend(@RequestBody FriendJson friendJson) {

        System.out.println(friendJson.getName());
        System.out.println(friendJson.getEmail());

        Friend friend = new Friend();
        friend.setName(friendJson.getName());
        friend.setEmail(friendJson.getEmail());
        friend.setFriends(new ArrayList<>());
        friendRepository.save(friend);
        return ResponseEntity.status(HttpStatus.CREATED).body(friend);
    }
}
