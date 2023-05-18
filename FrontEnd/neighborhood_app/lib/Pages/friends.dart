import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Friend.dart';
import '../Model/User.dart';

class AddFriends extends StatefulWidget {
  final User user;
  const AddFriends({Key? key, required this.user});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  late List<Friend> potentialFriends = [];
  late List<Friend> friendsrequests = [];

  @override
  void initState() {
    super.initState();
    getPotentialFriends(widget.user.email);
    getFriendRequests(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFriendRequests = friendsrequests.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Make connections"),
      ),
      body: Column(
        children: [
          if (hasFriendRequests)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Friend Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (hasFriendRequests)
            Container(
              height: 200,
              child: ListView.separated(
                itemCount: friendsrequests.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final friendRequest = friendsrequests[index];
                  return ListTile(
                    title: Text(friendRequest.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept friend request button press
                            acceptRequest(friendRequest);
                          },
                          child: const Text("Accept"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle decline friend request button press
                            //declineFriendRequest(friendRequest);
                          },
                          child: const Text("Decline"),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle onTap event for the friend request
                    },
                  );
                },
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Potential Friends",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200,
            child: ListView.separated(
              itemCount: potentialFriends.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final friend = potentialFriends[index];
                return ListTile(
                  title: Text(friend.name),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle add friend button press
                      addFriend(friend);
                    },
                    child: const Text("Add Friend"),
                  ),
                  onTap: () {
                    // Handle onTap event for the friend
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void acceptRequest(Friend friend) async {
    final url = 'http://localhost:8080/api/friends/add-friendship';
    final parameters = {
      'sender': widget.user.email,
      'receiver': friend.email,
    };

    final response = await http.post(Uri.parse(url), body: parameters);

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Friend Request Accepted"),
          content:
              Text("You have accepted the friend request from ${friend.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to accept friend request from ${friend.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void addFriend(Friend friend) async {
    final url = 'http://localhost:8080/api/friends/send-friend-request';
    final sender = Uri.encodeComponent(widget.user.email);
    final reciever = Uri.encodeComponent(friend.email);
    final requestUrl = '$url?sender=$sender&reciever=$reciever';

    final response = await http.post(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Friend Request Sent"),
          content: Text("Friend request sent to ${friend.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to send friend request to ${friend.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void getPotentialFriends(String email) async {
    const url = 'http://localhost:8080/api/friends/potential-friends';
    final uri = Uri.parse(url).replace(queryParameters: {'userEmail': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Friend> friends = [];

      for (var friendData in responseData) {
        Friend friend = Friend(
            name: friendData['name'] ?? '', email: friendData['email'] ?? '');
        friends.add(friend);
      }

      setState(() {
        potentialFriends = friends;
      });
    } else {
      throw Exception('Failed to load potential friends');
    }
  }

  void getFriendRequests(String email) async {
    final url = 'http://localhost:8080/api/friends/get-friend-requests';
    final uri = Uri.parse(url).replace(queryParameters: {'email': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Friend> friendRequests = [];

      for (var friendData in responseData) {
        Friend friend = Friend(
          name: friendData['name'] ?? '',
          email: friendData['email'] ?? '',
        );
        friendRequests.add(friend);
      }

      setState(() {
        friendsrequests = friendRequests;
      });
    } else {
      throw Exception('Failed to load friend requests');
    }
  }
}
