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

import java.util.ArrayList;
import java.util.List;

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

    @GetMapping("/all-posts") // returns all the post from the database in Json format
    public List<PostJson> getAllPosts() {
        List<Post> posts = postsRepo.findAll();
        List<PostJson> postJsonList = new ArrayList<>();

        for (Post post : posts) {
            PostJson postJson = new PostJson(post.getUser().getEmail(), post.getGroup().getGroupName(), post.getPost(),post.getid());
            postJsonList.add(postJson);
        }

        return postJsonList;
    }

    @GetMapping("/posts_group")
    public List<PostJson> getPosts(@RequestParam("groupName") String groupName) {
        List<Post> posts = postsRepo.findAll();
        List<PostJson> postJsonList = new ArrayList<>();

        for (Post post : posts) {
            if (post.getGroup() != null && post.getGroup().getGroupName().equals(groupName)) {
                PostJson postJson = new PostJson(post.getUser().getEmail(), post.getGroup().getGroupName(), post.getPost(),post.getid());
                postJsonList.add(postJson);
            }
        }

        return postJsonList;
    }

    @GetMapping("/posts_user")
    public List<PostJson> getPostsUser(@RequestParam("email") String email) {
        List<Post> posts = postsRepo.findAll();
        List<PostJson> postJsonList = new ArrayList<>();

        for (Post post : posts) {
            if (post.getGroup() != null && post.getUser().getEmail().equals(email)) {
                PostJson postJson = new PostJson(post.getUser().getEmail(), post.getGroup().getGroupName(), post.getPost(), post.getid());
                postJsonList.add(postJson);
            }
        }

        return postJsonList;
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
            Post createdPost = postsRepo.makePost(postContent, friendEmail, groupName);
            if (createdPost != null) {
                return ResponseEntity.status(HttpStatus.OK).body("Post created successfully.");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to create post.");
            }
        } else {
            return ResponseEntity.badRequest().body("Friend is not a member of the group.");
        }
    }


    @DeleteMapping("/remove-post_id")
    public ResponseEntity<String> removePost(@RequestParam("postId") Long postId) {
        boolean postExists = postsRepo.existsById(postId);

        if (postExists) {
            postsRepo.deleteById(postId);
            return ResponseEntity.ok("Post removed successfully");
        } else {
            return ResponseEntity.badRequest().body("Post not found");
        }
    }

    @DeleteMapping("/remove-post")
    public ResponseEntity<String> removePost(@RequestBody PostJson post) {


        String postContent = post.getPost();
        String email = post.getEmail();
        String groupName = post.getGroup();


        Group group = groupRepo.findByGroupName(groupName).orElse(null);
        Friend friend = frindRepo.findByEmail(email).orElse(null);


        if (group == null && friend == null) {
            return ResponseEntity.badRequest().body("Both friend and group do not exist.");
        } else if (group == null) {
            return ResponseEntity.badRequest().body("Group does not exist.");
        } else if (friend == null) {
            return ResponseEntity.badRequest().body("Friend does not exist.");
        }

        boolean postExists = postsRepo.deletePostByGroupEmailAndContentIfExists(groupName,email,postContent);


        if (postExists) {

            return ResponseEntity.ok("Post deleted successfully.");
        }
        return ResponseEntity.badRequest().body("Post does not exist.");
    }

}
