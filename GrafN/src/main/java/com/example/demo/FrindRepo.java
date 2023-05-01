package com.example.demo;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FrindRepo extends Neo4jRepository<Friend,Long> {

    @Query("MATCH (f:Friend)-[:FRIEND]->(friend:Friend) RETURN friend")
    List<Friend> findAllFriends();

    @Query("CREATE (f:Friend {name: $friendName, email: $friendEmail, friends: []}) RETURN f")
    Friend addFriend(@Param("friendName") String friendName, @Param("friendEmail") String friendEmail);


    Friend findByName(String name);

    @Query("MATCH (f:Friend) WHERE id(f) = $friendId SET f.friends = $friendList RETURN f")
    Friend updateFriendList(Long friendId, List<Friend> friendList);

    @Query("MATCH (f1:Friend {name: $friend1Name}), (f2:Friend {name: $friend2Name}) " +
            "WHERE NOT EXISTS((f1)-[:FRIEND]-(f2)) " +
            "CREATE (f1)-[:FRIEND]->(f2), (f2)-[:FRIEND]->(f1)")
    void addFriendship(@Param("friend1Name") String friend1Name, @Param("friend2Name") String friend2Name);


}
