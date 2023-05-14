package com.example.demo;

import com.example.demo.Model.Friend;
import com.example.demo.Repos.FrindRepo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;

import static org.junit.Assert.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;


@SpringBootTest
class FriendRepositoryTests {

    @Autowired
    private FrindRepo friendRepository;

    @Test
    public void testFindByEmail() {
        // create a test friend
        Friend friend = new Friend();
        friend.setName("John Doe");
        friend.setEmail("john.doe@example.com");
        friend.setPassword("password123");

        // save the friend to the database
        Friend savedFriend = friendRepository.save(friend);

        // test the findByEmail method
        Friend foundFriend = friendRepository.findByEmail("john.doe@example.com").orElse(null);
        assertNotNull(foundFriend);
        assertEquals(savedFriend.getId(), foundFriend.getId());
        assertEquals(savedFriend.getName(), foundFriend.getName());
        assertEquals(savedFriend.getEmail(), foundFriend.getEmail());
        assertEquals(savedFriend.getPassword(), foundFriend.getPassword());

        // delete the test friend from the database
        friendRepository.deleteById(savedFriend.getId());
    }

    @Test
    void testAddFriendshipById() {
        // create two friends
        Friend friend1 = new Friend();
        friend1.setName("a");
        friend1.setEmail("a");
        friend1.setPassword("password123");

        Friend friend2 = new Friend();
        friend2.setName("b");
        friend2.setEmail("b");
        friend2.setPassword("password123");


        Friend savedFriend1 = friendRepository.save(friend1);
        Friend savedFriend2 = friendRepository.save(friend2);

        // add friendship
        friendRepository.addFriendshipByEmail(friend1.getEmail(), friend2.getEmail());

        // retrieve both friends and check if they are now friends
        Friend foundFriend1 = friendRepository.findByEmail("a").orElse(null);
        Friend foundFriend2 = friendRepository.findByEmail("b").orElse(null);

        assertNotNull(foundFriend1);
        assertNotNull(foundFriend2);



        assertTrue(foundFriend1.getFriends().contains(foundFriend2));
        assertTrue(foundFriend2.getFriends().contains(foundFriend1));

        friendRepository.delete(foundFriend1);
        friendRepository.delete(foundFriend2);
    }

}
