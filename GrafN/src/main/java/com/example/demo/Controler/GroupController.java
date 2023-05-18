package com.example.demo.Controler;

import com.example.demo.Model.Friend;
import com.example.demo.Model.Group;
import com.example.demo.Model.GroupJson;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/group")
public class GroupController {

    private final GroupRepo groupRepo;
    private final FrindRepo friendRepository;

    @Autowired
    public GroupController(GroupRepo groupRepo, FrindRepo friendRepository) {
        this.groupRepo = groupRepo;
        this.friendRepository = friendRepository;
    }

    @PostMapping("/create-group")
    public ResponseEntity<String> createGroup(@RequestParam("groupName") String groupName) {
        // Check if the group already exists
        if (groupRepo.findByGroupName(groupName).isPresent()) {
            return ResponseEntity.badRequest().body("Group already exists.");
        }

        // Create new group
        Group group = new Group();
        group.setGroupName(groupName);
        groupRepo.save(group);

        return ResponseEntity.ok("Group created successfully.");
    }



    @PostMapping("/add-membership")
    public ResponseEntity<String> addMembership(@RequestParam("groupName") String groupName, @RequestParam("userEmail") String userEmail) {
        // Check if the grop and user  exist
        Group group = groupRepo.findByGroupName(groupName).orElse(null);
        Friend friend = friendRepository.findByEmail(userEmail).orElse(null);

        if (group == null || friend == null) {
            return ResponseEntity.badRequest().body("One or both  do not exist.");
        }
        // Check if the mebership relationship already exists
//        if (groupRepo.checkGroupMembership(groupId, userID)) {
//            return ResponseEntity.ok("User already in Gropu .");
//        }

        // Add friendship relationship
        //friend.getGroupList().add(group);

        groupRepo.addGroupDependency(groupName, userEmail);

        return ResponseEntity.ok("Membership added successfully.");//+ friend1Id + friend2Id);
    }

    @DeleteMapping("/remove-membership")
    public ResponseEntity<String> removeMembership(@RequestParam("groupName") String groupName, @RequestParam("userEmail") String userEmail) {
        // Check if the group and user  exist
        Group group = groupRepo.findByGroupName(groupName).orElse(null);
        Friend friend = friendRepository.findByEmail(userEmail).orElse(null);
        if (group == null || friend == null) {
            return ResponseEntity.badRequest().body("One or both  do not exist.");
        }
        groupRepo.removeGroupDependency(groupName,userEmail);
        return ResponseEntity.ok("Membership removed successfully.");
    }


//    @GetMapping("/potential-groups")
//    public ResponseEntity<List<Group>> getPotentialGroups(@RequestParam("userEmail") String userEmail) {
//        Optional<Friend> friendOptional = friendRepository.findByEmail(userEmail);
//        if (friendOptional.isEmpty()) {
//            return ResponseEntity.badRequest().body(Collections.emptyList());
//        }
//
//        Friend friend = friendOptional.get();
//        List<Group> potentialGroups = groupRepo.findPotentialGroups(friend.getEmail());
//
//        // Sort the potentialGroups list based on the number of friends in each group
//        potentialGroups.sort(Comparator.comparingInt(group -> {
//            int friendCount = groupRepo.getFriendCountInGroup(friend.getEmail(), group.getGroupName());
//            return -friendCount; // negate the count to sort in descending order
//        }));
//
//        return ResponseEntity.ok(potentialGroups);
//    }






    @GetMapping("/potential-groups")
    public ResponseEntity<List<GroupJson>> getPotentialGroups(@RequestParam("userEmail") String userEmail) {
        Optional<Friend> friendOptional = friendRepository.findByEmail(userEmail);
        if (friendOptional.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        Friend friend = friendOptional.get();
        List<Group> potentialGroups = groupRepo.findPotentialGroups(friend.getEmail());

        List<GroupJson> groupJsonList = new ArrayList<>();
        for (Group group : potentialGroups) {
            GroupJson groupJson = new GroupJson();
            groupJson.setGroupName(group.getGroupName());
            groupJson.setLocation(group.getLocation());
            groupJson.setMemberList(group.getMemberList());
            int numCommonFriends = groupRepo.getFriendCountInGroup(friend.getEmail(), group.getGroupName());
            groupJson.setNumCommonFriends(numCommonFriends);
            groupJsonList.add(groupJson);
        }

        // Sort the groupJsonList based on the number of common friends in descending order
        groupJsonList.sort(Comparator.comparingInt(GroupJson::getNumCommonFriends).reversed());

        return ResponseEntity.ok(groupJsonList);
    }



    @GetMapping("/user-groups")
    public ResponseEntity<List<Group>> getUserGroups(@RequestParam("userEmail") String userEmail) {
        Optional<Friend> friendOptional = friendRepository.findByEmail(userEmail);
        if (friendOptional.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        Friend friend = friendOptional.get();
        List<Group> userGroups = groupRepo.findUserGroups(friend.getEmail());

        return ResponseEntity.ok(userGroups);
    }













}
