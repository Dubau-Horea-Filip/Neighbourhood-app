package com.example.demo.Repos;

import com.example.demo.Model.Friend;
import com.example.demo.Model.Group;
import com.example.demo.Model.User;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface GroupRepo extends Neo4jRepository<Group,Long> {






    @Query("MATCH (u:Friend)-[:GROUP]->(g:Group {groupName: $groupName}) WHERE NOT EXISTS((u)-[:FRIEND]->(:Friend {email: $userEmail})) RETURN u")
    List<Friend> findNonFriendUsersInGroup(@Param("groupName") String groupName, @Param("userEmail") String userEmail);



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



    @Query("MATCH (g:Group {id: $groupId}), (f:Friend {id: $friendId}) RETURN EXISTS((f)-[:GROUP]->(g))")
    boolean checkGroupMembership(@Param("groupId") Long groupId, @Param("friendId") Long friendId);

//    @Query("MATCH (g:Group {groupName: $groupName})<-[:GROUP]-(f:Friend {email: $friendEmail}) RETURN EXISTS((f)-[:GROUP]->(g))")
//    boolean checkGroupMembership(@Param("groupName") String groupName, @Param("friendEmail") String friendEmail);

    @Query("MATCH (g:Group {groupName: $groupName})<-[:GROUP]-(f:Friend {email: $friendEmail}) RETURN EXISTS((f)-[:GROUP]->(g))")
    Boolean checkGroupMembership(@Param("groupName") String groupName, @Param("friendEmail") String friendEmail);



    @Query("MATCH (f:Friend {email: $friendEmail})-[:GROUP]->(g:Group) RETURN g")
    List<Group> findUserGroups(@Param("friendEmail") String friendEmail);


    @Query("MATCH (g:Group) WHERE NOT EXISTS((:Friend {email: $friendEmail})-[:GROUP]->(g)) RETURN g")
    List<Group> findPotentialGroups(@Param("friendEmail") String friendEmail);


    @Query("MATCH (:Friend {email: $userEmail})-[:FRIEND]->(f:Friend)-[:GROUP]->(:Group {groupName: $groupName}) RETURN count(f)")
    int getFriendCountInGroup(@Param("userEmail") String userEmail, @Param("groupName") String groupName);

    @Query("MATCH (:Friend {email: $userEmail})-[:GROUP]->(g:Group)<-[:GROUP]-(:Friend {email: $friendEmail}) RETURN g")
    List<Group> findMutualGroups(@Param("userEmail") String userEmail, @Param("friendEmail") String friendEmail);

    @Query("MATCH (u:Friend)-[:GROUP]->(g:Group {groupName: $groupName}) WHERE NOT EXISTS((u)-[:FRIEND]->(:Friend {email: $userEmail})) RETURN u.email")
    List<String> findNonFriendUserEmailsInGroup(@Param("groupName") String groupName, @Param("userEmail") String userEmail);








}
