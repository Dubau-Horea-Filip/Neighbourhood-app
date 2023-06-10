package com.example.demo.Controler;

import com.example.demo.Model.Friend;
import com.example.demo.Model.FriendJson;
import com.example.demo.Model.Group;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/friends")
public class FriendController {

    @Autowired
    private PasswordEncoder passwordEncoder;
    private final FrindRepo friendRepository;

    private final GroupRepo groupRepo;

    @Autowired
    public FriendController(FrindRepo friendRepository, GroupRepo groupRepo) {
        this.friendRepository = friendRepository;
        this.groupRepo = groupRepo;
    }

    @GetMapping
    public List<Friend> getAllFriends() {  // returns all users
        return friendRepository.findAll();
    }


    public boolean isValidUser(String email, String password) { //checks login info

        Friend user = friendRepository.findByEmail(email).orElse(null);
        if (user == null) {
            return false;
        }
        System.out.println(password);
        String criptedPassword = passwordEncoder.encode(password);
        System.out.println(criptedPassword);
        return passwordEncoder.matches(password, user.getPassword());
    }


    @GetMapping("/user") // get information about current user, needing password
    public FriendJson getUserIfCredentials(@RequestParam("UserEmail") String UserEmail, @RequestParam("UserPassword") String UserPassword) {

        if (isValidUser(UserEmail, UserPassword)) {
            Friend user = friendRepository.findByEmail(UserEmail).orElse(null);
            FriendJson userJ = new FriendJson();
            assert user != null;
            userJ.setEmail(user.getEmail());
            userJ.setName(user.getName());
            userJ.setFrinds_emails(user.getFriendEmails());
            userJ.setGroupsName(user.getGroupNames());
            return userJ;
        }

        return null;
    }

    @GetMapping("/userL") // get information about current user
    public FriendJson getUserIfCredentials(@RequestParam("UserEmail") String UserEmail) {

        Friend user = friendRepository.findByEmail(UserEmail).orElse(null);
        if (user != null) {

            FriendJson userJ = new FriendJson();
            userJ.setEmail(user.getEmail());
            userJ.setName(user.getName());
            //userJ.setFrinds_emails(user.getFriendEmails());
            userJ.setGroupsName(user.getGroupNames());
            return userJ;
        }


        return null;
    }


    @PostMapping("/add")  //add a new user
    public ResponseEntity<Friend> addFriend(@RequestBody FriendJson friendJson) {

        String email = friendJson.getEmail();
        if (friendRepository.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }

        System.out.println(friendJson.getName());
        System.out.println(friendJson.getEmail());

        Friend friend = new Friend();
        friend.setName(friendJson.getName());
        friend.setEmail(friendJson.getEmail());
        friend.setFriends(new ArrayList<>());
        String encryptedPassword = passwordEncoder.encode(friendJson.getPassword());
        friend.setPassword(encryptedPassword);
        friendRepository.save(friend);
        return ResponseEntity.status(HttpStatus.CREATED).body(friend);
    }

    @PostMapping("/send-friend-request")
    public ResponseEntity<String> sendFrindRequest(@RequestParam("sender") String sender, @RequestParam("reciever") String reciever) {
        Friend senderEmail = friendRepository.findByEmail(sender).orElse(null);
        Friend ReceiverEmail = friendRepository.findByEmail(reciever).orElse(null);
        if (senderEmail == null || ReceiverEmail == null) {
            return ResponseEntity.badRequest().body("One or both friends do not exist.");
        }
        List<Friend> friendRequests = ReceiverEmail.getFriendRequests();
        if (friendRequests.contains(senderEmail)) {
            return ResponseEntity.badRequest().body("Friend request already exists.");
        }

        ReceiverEmail.getFriendRequests().add(senderEmail);
        friendRepository.save(ReceiverEmail);
        return ResponseEntity.ok("sent friend request");
    }

    @GetMapping("/get-friend-requests")
    public ResponseEntity<List<Friend>> getFriendRequest(@RequestParam("email") String reciever) {
        Friend friend = friendRepository.findByEmail(reciever).orElse(null);
        if (friend == null) {
            return null;
        }
        List<Friend> friendRequests = friend.getFriendRequests();
        return ResponseEntity.ok(friendRequests);
    }


    @PostMapping("/add-friendship")  // add a frind dependency
    public ResponseEntity<String> addFriendship(@RequestParam("sender") String sender, @RequestParam("receiver") String receiver) {
        // Check if the friends with the given IDs exist
        Friend friend1 = friendRepository.findByEmail(sender).orElse(null);
        Friend friend2 = friendRepository.findByEmail(receiver).orElse(null);


        if (friend1 == null || friend2 == null) {
            return ResponseEntity.badRequest().body("One or both friends do not exist.");
        }

        friend2.getFriendRequests().remove(friend1);
        friend1.getFriendRequests().remove(friend2);
        friendRepository.save(friend2);
        friendRepository.save(friend1);

        // Check if the friendship relationship already exists
        if (friendRepository.checkFriendshipByEmail(receiver, sender)) {
            return ResponseEntity.ok("Friendship already exists.");
        }

        // Add friendship relationship
        friendRepository.addFriendshipByEmail(sender, receiver);

        return ResponseEntity.ok("Friendship added successfully.");//+ friend1Id + friend2Id);
    }

    @PutMapping("/update")
    public ResponseEntity<String> updateUserAbout(@RequestParam("UserEmail") String UserEmail, @RequestParam("UserAbout") String UserAbout , @RequestParam("UserDisplayName") String UserDisplayName ) {
        // Check if user with the given email exists
        Friend user = friendRepository.findByEmail(UserEmail).orElse(null);
        if (user == null) {
            return ResponseEntity.badRequest().body("User with email " + UserEmail + " does not exist.");
        }

        user.setAbout(UserAbout);
        user.setName(UserDisplayName);
        friendRepository.save(user);

        return ResponseEntity.ok("User updated successfully.");
    }


    @GetMapping("/potential-friends")
    public ResponseEntity<List<Friend>> getPotentialFriends(@RequestParam("userEmail") String userEmail) {
        Friend user = friendRepository.findByEmail(userEmail).orElse(null);
        if (user != null) {
            Set<Friend> potentialFriends = new HashSet<>();

            for (Friend friend : user.getFriends()) {
                List<Friend> mutualFriends = friendRepository.findFriendsByEmail(friend.getEmail());
                for (Friend friend2 : mutualFriends) {
                    if (!friend2.getEmail().equals(userEmail) && !user.getFriends().contains(friend2)) {
                        potentialFriends.add(friend2);
                    }
                }
            }

            // Add friends from the same groups as the user
            List<Group> userGroups = groupRepo.findUserGroups(userEmail);
            System.out.println("User groups: " + userGroups);
            for (Group group : userGroups) {
                List<String> groupMembers = groupRepo.findNonFriendUserEmailsInGroup(group.getGroupName(), userEmail);

                for (String friend2 : groupMembers) {
                    if (!userEmail.equals(friend2) && !user.getFriends().contains(friend2)) {
                        friendRepository.findByEmail(friend2).ifPresent(potentialFriends::add);
                    }
                }
            }

            return ResponseEntity.ok(new ArrayList<>(potentialFriends));
        }

        return ResponseEntity.notFound().build();
    }


}
