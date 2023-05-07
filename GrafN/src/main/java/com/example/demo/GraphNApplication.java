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

	public void addFrindship(String friend1, String friend2)
	{

		friendsRepo.addFriendship(friend1,friend2);
		//friendsRepo.addFriendship(friend2,friend1);
	}

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


	public void addUser()
	{

		Group newGroup = groupRepo.addGroup("Cluj-Napoca, Romania", "Gheorgheni");
		System.out.println(newGroup);

		friendsRepo.addFriend("Iulian","Ioolean@gmail.com");
		friendsRepo.addFriend("Filip","filipdubau@yahoo.ro");
		addFrindship("Iulian","Filip");


	}


	@Override
	public void run(String... args) throws Exception {

		//addUser();
		seeall();
	}}

