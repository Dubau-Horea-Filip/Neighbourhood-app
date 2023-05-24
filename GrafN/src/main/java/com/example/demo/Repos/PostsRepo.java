package com.example.demo.Repos;

import com.example.demo.Model.Friend;
import com.example.demo.Model.Post;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostsRepo extends Neo4jRepository<Post,Long> {



    @Query("MATCH (f:Friend {email: $friendEmail})\n" +
            "MATCH (g:Group {groupName: $groupName})\n" +
            "CREATE (p:Post {post: $postContent})-[:CREATED_BY]->(f)\n" +
            "CREATE (p)-[:POSTED_IN]->(g)\n" +
            "RETURN p\n")
    Post makePost(@Param("postContent") String postContent, @Param("friendEmail") String friendEmail, @Param("groupName") String groupName);



    @Query("MATCH (p:Post)-[r]-(n) WHERE ID(p) = $postId DELETE p, r RETURN COUNT(p) + COUNT(r)")
    void removePost(@Param("postId") Long postId);

    @Query("MATCH (p:Post)-[:POSTED_IN]->(g:Group {groupName: $groupName}) RETURN p")
    List<Post> findPostsByGroupName(@Param("groupName") String groupName);


    @Query("MATCH (p:Post)-[r:CREATED_BY]->(f:Friend {email: $email})-[:POSTED_IN]->(g:Group {groupName: $groupName}) " +
            "WHERE p.post = $postContent " +
            "RETURN p")
    Post findPostByGroupEmailAndContent(@Param("groupName") String groupName,
                                        @Param("email") String email,
                                        @Param("postContent") String postContent);

    @Query("MATCH (p:Post)-[r:CREATED_BY]->(f:Friend {email: $email})-[:POSTED_IN]->(g:Group {groupName: $groupName}) " +
            "WHERE p.post = $postContent " +
            "RETURN COUNT(p) > 0")
    boolean existsPostByGroupEmailAndContent(@Param("groupName") String groupName,
                                             @Param("email") String email,
                                             @Param("postContent") String postContent);




    @Query("MATCH (p:Post)-[r:CREATED_BY]->(f:Friend {email: $email})-[:POSTED_IN]->(g:Group {groupName: $groupName}) " +
            "WHERE p.post = $postContent " +
            "DELETE p, r")
    void deletePostByGroupEmailAndContent(@Param("groupName") String groupName,
                                          @Param("email") String email,
                                          @Param("postContent") String postContent);

    @Query( "MATCH (f:Friend {email: $email}) " +
            "MATCH (g:Group {groupName: $groupName})"+
            "MATCH (g)-[:POSTED_IN]-(p:Post)-[:CREATED_BY]->(f) " +
            "WHERE p.post = $postContent " +
            "WITH p, g, f " +
            "LIMIT 1 " +
            "DETACH DELETE p " +
            "RETURN COUNT(p) > 0")
    boolean deletePostByGroupEmailAndContentIfExists(@Param("groupName") String groupName,
                                                     @Param("email") String email,
                                                     @Param("postContent") String postContent);





}
