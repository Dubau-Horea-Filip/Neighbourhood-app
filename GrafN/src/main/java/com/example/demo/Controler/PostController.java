package com.example.demo.Controler;


import com.example.demo.Model.Friend;
import com.example.demo.Model.Group;
import com.example.demo.Model.Post;
import com.example.demo.Model.PostJson;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import com.example.demo.Repos.PostsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/post")
public class PostController {

private final GroupRepo groupRepo;

    private final PostsRepo postsRepo;
    private final FrindRepo frindRepo;

    @Autowired
    public PostController(GroupRepo groupRepo, PostsRepo postsRepo, FrindRepo frindRepo) {
        this.groupRepo = groupRepo;
        this.postsRepo = postsRepo;
        this.frindRepo = frindRepo;
    }

    @PostMapping
    public ResponseEntity<String> createPost(@RequestBody PostJson post) {
        String postContent = post.getPost();
        String friendEmail = post.getEmail();
        String groupName = post.getGroup();

        Group group = groupRepo.findByGroupName(groupName).orElse(null);
        Friend friend = frindRepo.findByEmail(friendEmail).orElse(null);

        if (group == null && friend == null) {
            return ResponseEntity.badRequest().body("Both friend and group do not exist.");
        } else if (group == null) {
            return ResponseEntity.badRequest().body("Group does not exist.");
        } else if (friend == null) {
            return ResponseEntity.badRequest().body("Friend does not exist.");
        }

        // Check if the friend is a member of the specified group


        Boolean membership = groupRepo.checkGroupMembership(groupName, friendEmail);
        if (membership != null && membership) {
            // Perform the desired logic when the membership is true



            // Create the post
            Post createdPost = postsRepo.makePost(postContent,friendEmail, groupName);
            if (createdPost != null) {
                return ResponseEntity.status(HttpStatus.OK).body("Post created successfully.");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to create post.");
            }
        } else {
            return ResponseEntity.badRequest().body("Friend is not a member of the group.");
        }
    }
    @DeleteMapping("/remove-post")
    public ResponseEntity<String> removePost(@RequestParam("postId") Long postId) {
        boolean postExists = postsRepo.existsById(postId);

        if (postExists) {
            postsRepo.deleteById(postId);
            return ResponseEntity.ok("Post removed successfully");
        } else {
            return ResponseEntity.badRequest().body("Post not found");
        }
    }




}