package com.example.demo.Controler;

import com.example.demo.Model.Friend;
import com.example.demo.Model.FriendJson;
import com.example.demo.Repos.FrindRepo;
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

    public boolean isValidUser(String email, String password) {
        Friend user = friendRepository.findByEmail(email).orElse(null);
        if (user == null) {
            return false;
        }
        return user.getPassword().equals(password);
    }

    @GetMapping("/user")
    public Friend getUserIfCredentials(@RequestParam("UserEmail") String UserEmail, @RequestParam("UserPassword") String UserPassword) {

        if(isValidUser(UserEmail,UserPassword))
        {
            Friend user = friendRepository.findByEmail(UserEmail).orElse(null);
            return user;
        }

        return null;
    }


    @PostMapping("/add")  //add a new user
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

    @PostMapping("/add-friendship")
    public ResponseEntity<String> addFriendship(@RequestParam("friend1Id") Long friend1Id, @RequestParam("friend2Id") Long friend2Id) {
        // Check if the friends with the given IDs exist
        Friend friend1 = friendRepository.findById(friend1Id).orElse(null);
        Friend friend2 = friendRepository.findById(friend2Id).orElse(null);

        if (friend1 == null || friend2 == null) {
            return ResponseEntity.badRequest().body("One or both friends do not exist.");
        }
        // Check if the friendship relationship already exists
        if (friendRepository.checkFriendshipById(friend1Id, friend2Id)) {
            return ResponseEntity.ok("Friendship already exists.");
        }

        // Add friendship relationship

        friendRepository.addFriendshipById(friend1Id, friend2Id);

        return ResponseEntity.ok("Friendship added successfully.");//+ friend1Id + friend2Id);
    }
}
