package com.example.demo.Repos;

import com.example.demo.Model.Comment;
import com.example.demo.Model.Friend;
import com.example.demo.Model.Post;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentRepo extends Neo4jRepository<Comment,Long> {


    @Query("MATCH (f:Friend {email: $friendEmail})\n" +
            "MATCH (p:Post {id: $postId})\n" +
            "CREATE (c:Comment {comment: $comment})-[:COMMENT_BY]->(f)\n" +
            "CREATE (c)-[:COMMENT_IN]->(p)\n" +
            "RETURN c\n")
    Comment makeComment(@Param("comment") String comment, @Param("friendEmail") String friendEmail, @Param("postId") String postId);


    @Query("MATCH (c:Comment) WHERE id(c) = $commentId DETACH DELETE c")
    void deleteCommentById(@Param("commentId") Long commentId);

    @Query("MATCH (p:Post)-[:COMMENT_IN]->(c:Comment)\n" +
            "WHERE p.id = $postId\n" +
            "RETURN c\n")
    List<Comment> findCommentsByPostId(@Param("postId") Long postId);

}
