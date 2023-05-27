package com.example.demo.Controler;


import com.example.demo.Model.*;
import com.example.demo.Repos.CommentRepo;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import com.example.demo.Repos.PostsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    private final GroupRepo groupRepo;

    private final PostsRepo postsRepo;
    private final FrindRepo frindRepo;

    private final CommentRepo commentRepo;

    @Autowired
    public CommentController(GroupRepo groupRepo, PostsRepo postsRepo, FrindRepo frindRepo, CommentRepo commentRepo) {
        this.groupRepo = groupRepo;
        this.postsRepo = postsRepo;
        this.frindRepo = frindRepo;
        this.commentRepo = commentRepo;
    }

    @PostMapping("/make-comm")
    public ResponseEntity<String> createComment(@RequestBody CommentJson com) {
        String commentContent = com.getComment();
        String friendEmail = com.getEmail();
        Long postId = com.getPostId();

        Post post = postsRepo.findById(postId).orElse(null);
        Friend friend = frindRepo.findByEmail(friendEmail).orElse(null);

        if (post == null && friend == null) {
            return ResponseEntity.badRequest().body("Both friend and group do not exist.");
        } else if (post == null) {
            return ResponseEntity.badRequest().body("post does not exist.");
        } else if (friend == null) {
            return ResponseEntity.badRequest().body("Friend does not exist.");
        }


    Comment newComet = new Comment();
    newComet.setComment(commentContent);
    newComet.setPost(post);
    newComet.setUser(friend);
    commentRepo.save(newComet);
        return ResponseEntity.status(HttpStatus.OK).body("Comment created successfully.");
    }

    @DeleteMapping("/remove-comment")
    public ResponseEntity<String> removeComment(@RequestBody Map<String, String> requestBody) {
        String id = requestBody.get("id");
        try {
            Long commentId = Long.parseLong(id);
            boolean commentExists = commentRepo.existsById(commentId);

            if (commentExists) {
                commentRepo.deleteById(commentId);
                return ResponseEntity.ok("Comment deleted successfully.");
            } else {
                return ResponseEntity.badRequest().body("Comment does not exist.");
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid comment ID format.");
        }
    }


}

