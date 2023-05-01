package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.ArrayList;
import java.util.List;

@SpringBootApplication
public class GraphNApplication implements CommandLineRunner {

	@Autowired
	private  FrindRepo friendsRepo;
	@Autowired
	private  UserRepo userRepo;

	public static void main(String[] args) {
		SpringApplication.run(GraphNApplication.class, args);
	}

	public GraphNApplication(FrindRepo friendsRepo, UserRepo userRepo) {
		this.friendsRepo = friendsRepo;
		this.userRepo = userRepo;
	}

	public void addFrindship(String friend1, String friend2)
	{

		friendsRepo.addFriendship(friend1,friend2);
		friendsRepo.addFriendship(friend2,friend1);
	}

	public void seeall() {
		System.out.println("Users:");
		for (User user : userRepo.findAll()) {
			System.out.println(user);
		}

		System.out.println("Friends:");
		for (Friend friend : friendsRepo.findAll()) {
			System.out.println(friend);
		}
	}


	public void addUser()
	{

		User a = new User("user1",5);
		User b = new User("user2",6);
		userRepo.save(a);
		userRepo.save(b);

//		List<Friend> friends = new ArrayList<>();
//		List<Friend> friends2 = new ArrayList<>();
//		FriendFromDb IulianD = new FriendFromDb("Iulian","Ioolean@gmail.com",new ArrayList<>());
//		FriendFromDb FilipD = new FriendFromDb("Filip","filipdubau@yahoo.ro",new ArrayList<>());
//
//
//		//Friend Filip = new Friend(FilipD);
//		//Friend Iulian = new Friend(IulianD);

//
//		//Filip.getFriends().add(Iulian);
//		//Iulian.getFriends().add(Filip);
//
//		//friendsRepo.save(Filip);
//		//friendsRepo.save(Iulian);


		friendsRepo.addFriend("Iulian","Ioolean@gmail.com");
		friendsRepo.addFriend("Filip","filipdubau@yahoo.ro");
		addFrindship("Iulian","Filip");

	}


	@Override
	public void run(String... args) throws Exception {

		//addUser();
		seeall();
	}}

//			friends.add(friendsRepo.findByName("Filip")) ;
//		Friend Iulian = friendsRepo.findByName("Iulian");
//		Friend Filip = friendsRepo.findByName("Filip");
//		friendsRepo.updateFriendList(Iulian.getId(),friends);


//	List<Friend> friends = new ArrayList<>();
//		List<Friend> friends2 = new ArrayList<>();
//		Friend friend1 = new Friend("John", "john@example.com", friends, friends);
//		Friend friend2 = new Friend("Jane", "jane@example.com", friends2, friends2);
//
//		List<Friend> listofFrind1 = friend1.getFriends();
//		listofFrind1.add(friend2);
//		System.out.println(listofFrind1);
//		friend1.setFriendOf(listofFrind1);
//		friend2.getFriendOf().add(friend1);
//
//		friendsRepo.save(friend1);
//		friendsRepo.save(friend2);
//
//

		//Friend Filip = friendsRepo.findByName("Filip");
		//Friend John = friendsRepo.findByName("John");
		//addFrindship(friendsRepo.findByName("Filip"),friendsRepo.findByName("John"));

//		friendsRepo.addFriend("Filip","John");
//		friendsRepo.addFriend("John","Filip");
