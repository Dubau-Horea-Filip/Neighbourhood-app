package com.example.demo.Repos;

import com.example.demo.Model.Friend;
import com.example.demo.Model.Group;
import com.example.demo.Model.User;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface GroupRepo extends Neo4jRepository<Group,Long> {



//    @Query("MATCH (g:Group) WHERE id(g) = $groupId RETURN g")
//    Optional<Group> findById(@Param("groupId") Long groupId);

    Optional<Group> findByGroupName(String name);
    @Query("CREATE (g:Group {location: $location, groupName: $groupName}) RETURN g")
    Group addGroup(@Param("location") String location, @Param("groupName") String groupName);



    @Query("MATCH (g:Group {groupName: $groupName})\n" +
            "MATCH (f:Friend {email: $friendEmail})\n" +
            "WHERE NOT EXISTS((f)-[:GROUP]-(g)) " +
            "CREATE (f)-[:GROUP]->(g)\n")
    void addGroupDependency(@Param("groupName") String groupName, @Param("friendEmail") String friendEmail);

    @Query("MATCH (g:Group {groupName: $groupName})<-[r:GROUP]-(f:Friend {email: $friendEmail})\n" +
            "DELETE r")
    void removeGroupDependency(@Param("groupName") String groupName, @Param("friendEmail") String friendEmail);


//    @Query("MATCH (f1:Friend {name: $friend1Name}), (f2:Friend {name: $friend2Name}) " +
//            "WHERE NOT EXISTS((f1)-[:FRIEND]-(f2)) " +
//            "CREATE (f1)-[:FRIEND]->(f2), (f2)-[:FRIEND]->(f1)")
//    void addFriendship(@Param("friend1Name") String friend1Name, @Param("friend2Name") String friend2Name); //add frind dependency

    @Query("MATCH (g:Group {id: $groupId}), (f:Friend {id: $friendId}) RETURN EXISTS((f)-[:GROUP]->(g))")
    boolean checkGroupMembership(@Param("groupId") Long groupId, @Param("friendId") Long friendId);




    @Query("MATCH (f:Friend {email: $friendEmail})-[:GROUP]->(g:Group) RETURN g")
    List<Group> findUserGroups(@Param("friendEmail") String friendEmail);


    @Query("MATCH (g:Group) WHERE NOT EXISTS((:Friend {email: $friendEmail})-[:GROUP]->(g)) RETURN g")
    List<Group> findPotentialGroups(@Param("friendEmail") String friendEmail);


    @Query("MATCH (:Friend {email: $userEmail})-[:FRIEND]->(f:Friend)-[:GROUP]->(:Group {groupName: $groupName}) RETURN count(f)")
    int getFriendCountInGroup(@Param("userEmail") String userEmail, @Param("groupName") String groupName);








}
