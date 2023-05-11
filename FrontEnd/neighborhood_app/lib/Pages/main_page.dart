import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborhood_app/Pages/profile_page.dart';
import 'package:http/http.dart' as http;
import '../Model/User.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/list_of_frinds_from_user.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({required this.user, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<User> users = [];

  @override
  void initState() {
    super.initState();
    populateUsersFromFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:  NavBar( user: widget.user),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 104, 26, 26),
          title: const Text("Home Page"),
          
          actions: [
            IconButton(
              splashRadius: 25,
              icon: const CircleAvatar(
                minRadius: 25,
                // foregroundImage: Image.asset(
                //   'assets/Krunal.jpg',
                // ),
                // backgroundImage: Image.asset('assets/profile.png'),
                child: Text("profile"),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Profile()));
              },
            ),
          ],
        ),
        body: users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : UserListWidget(users: users),
        backgroundColor: const Color.fromARGB(255, 49, 49, 49));
  }

  Future<void> populateUsersFromFriends() async {
    final List<User> userList = [];
    for (final friendEmail in widget.user.friends) {
      final userData = await getUserDataByEmail(friendEmail);
      if (userData == null) {
        return;
      }
      final user = User.fromJson(userData);
      userList.add(user);
    }
    setState(() {
      users = userList;
    });
  }

  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    const url = 'http://localhost:8080/api/friends/userL';
    final uri = Uri.parse(url).replace(queryParameters: {'UserEmail': email});
    final response = await http.get(uri);
    final body = response.body;
    if (body.isNotEmpty && response.statusCode == 200) {
      final parsedJson = json.decode(body);
      return parsedJson;
    }
    return null;
  }
}
