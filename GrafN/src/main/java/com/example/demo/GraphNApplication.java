package com.example.demo;

import com.example.demo.Model.Friend;
import com.example.demo.Model.FriendFromDb;
import com.example.demo.Model.Group;
import com.example.demo.Model.User;
import com.example.demo.Repos.FrindRepo;
import com.example.demo.Repos.GroupRepo;
import com.example.demo.Repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.ArrayList;
import java.util.List;

@SpringBootApplication
public class GraphNApplication implements CommandLineRunner {

	@Autowired
	private FrindRepo friendsRepo;
	@Autowired
	private UserRepo userRepo;

	@Autowired
	private GroupRepo groupRepo;

	public static void main(String[] args) {
		SpringApplication.run(GraphNApplication.class, args);
	}

	public GraphNApplication(FrindRepo friendsRepo, UserRepo userRepo, GroupRepo groupRepo) {
		this.friendsRepo = friendsRepo;
		this.userRepo = userRepo;
		this.groupRepo = groupRepo;
	}

//	public void addFrindship(String email1, String email2)
//	{
//		Friend friend1 = friendsRepo.findByEmail(email1).orElseThrow(() -> new RuntimeException("Friend with id " + email1 + " not found"));
//		Friend friend2 = friendsRepo.findByEmail(email2).orElseThrow(() -> new RuntimeException("Friend with id " + email2 + " not found"));
//
//		friend1.getFriends().add(friend2);
//		friend2.getFriends().add(friend1);
//
//		//friendsRepo.updateFriendList(email1,friend1.getFriends());
//		//friendsRepo.updateFriendList(email2,friend2.getFriends());
//		friendsRepo.save(friend1);
//		friendsRepo.save(friend2);
//
//		friendsRepo.addFriendshipByEmail(email1,email2);
//
//	}
//
	public void seeall() {

		System.out.println("Friends:");
		for (Friend friend : friendsRepo.findAll()) {
			System.out.println(friend);
		}

		System.out.println("Group:");
		for (Group friend : groupRepo.findAll()) {
			System.out.println(friend);
		}
	}

//	private void addGrops() {
//		Group newGroup = groupRepo.addGroup("Cluj-Napoca, Romania", "Gheorgheni");
//		System.out.println(newGroup);
//	}
//
//
//	public void addUser()
//	{
//
//		Group newGroup = groupRepo.addGroup("Cluj-Napoca, Romania", "Gheorgheni");
//		System.out.println(newGroup);
//
//		friendsRepo.addFriend("Iulian","Ioolean@gmail.com","Rio");
//		friendsRepo.addFriend("Filip","filipdubau@yahoo.ro","Filip");
//		friendsRepo.addFriend("Andrei Malan","malan@gmail.com","Eurovision");
//		friendsRepo.addFriend("Birtalan Csaba","csaby@gmail.com","Anime");
//
//		addFrindship("Ioolean@gmail.com","filipdubau@yahoo.ro");
//		addFrindship("Ioolean@gmail.com","malan@gmail.com");
//		addFrindship("csaby@gmail.com","filipdubau@yahoo.ro");
//		addFrindship("malan@gmail.com","filipdubau@yahoo.ro");
//
//		groupRepo.addGroupDependency("Gheorgheni","malan@gmail.com");
//		groupRepo.addGroupDependency("Gheorgheni","Ioolean@gmail.com");
//		groupRepo.addGroupDependency("Gheorgheni","csaby@gmail.com");
//		groupRepo.addGroupDependency("Gheorgheni","filipdubau@yahoo.ro");
//
//
//	}


	@Override
	public void run(String... args) throws Exception {
		//addGrops();
		//addUser();
		seeall();
	}


}

