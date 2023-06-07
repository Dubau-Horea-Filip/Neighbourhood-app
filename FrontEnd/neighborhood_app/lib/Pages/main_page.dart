import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Post.dart';
import '../Model/User.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/post_list_widget.dart';
import '../new/profile.dart';
import 'newPostPage.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({required this.user, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<User> users = [];
  late List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    populateUsersFromFriends();
    populatePostsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(user: widget.user),
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: const Text("Home Page"),

        actions: [
          IconButton(
            splashRadius: 25,
            icon: const CircleAvatar(
              minRadius: 25,
              //backgroundImage: NetworkImage(widget.user.pictureurl),
              // foregroundImage: Image.asset(
              //   'assets/Krunal.jpg',
              // ),
              // backgroundImage: Image.asset('assets/profile.png'),
              child: Text("profile"),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            user: widget.user,
                          )));
            },
          ),
        ],
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PostListWidget(
              posts: posts,
              user: widget.user,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => NewPostPage(
                        user: widget.user,
                      )));
          await populatePostsForCurrentUser();
          setState(() {}); // Trigger a rebuild of the MainPage
        },
        tooltip: "add",
        child: const Icon(Icons.add),
      ),

      //backgroundColor: const Color.fromARGB(255, 49, 49, 49)
    );
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

  Future<void> populatePostsForCurrentUser() async {
    final List<Post> updatedPosts = [];

    for (final groupName in widget.user.groups) {
      final List<dynamic>? groupData =
          await getUserGroupsByGroupName(groupName);

      if (groupData != null) {
        final List<Post> groupPosts = groupData
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
        updatedPosts.addAll(groupPosts);
      }
    }

    setState(() {
      posts = updatedPosts;
    });
  }

  Future<List<dynamic>?> getUserGroupsByGroupName(String groupname) async {
    const url = 'http://localhost:8080/api/post/posts_group';
    final uri =
        Uri.parse(url).replace(queryParameters: {'groupName': groupname});
    final response = await http.get(uri);
    final body = response.body;
    if (body.isNotEmpty && response.statusCode == 200) {
      final parsedJson = json.decode(body);
      return parsedJson;
    }
    return null;
  }
}
