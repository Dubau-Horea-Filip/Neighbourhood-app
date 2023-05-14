package com.example.demo.Controler;

import com.example.demo.Model.Friend;
import com.example.demo.Model.Group;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

}
