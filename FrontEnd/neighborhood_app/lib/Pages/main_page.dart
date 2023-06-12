import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Post.dart';
import '../Model/User.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/post_list_widget.dart';
import '../new/profile.dart';
import 'friends.dart';
import 'logging_screen.dart';
import 'newPostPage.dart';
import 'new_gropus_frinds.dart';

class MainPage extends StatefulWidget {
  User user;

  MainPage({required this.user, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //late List<User> users = [];
  late List<Post> posts = [];
  //var user;
  @override
  void initState() {
    super.initState();
    //user = widget.user;
    updateUser();
    //populateUsersFromFriends();
    populatePostsForCurrentUser();
  }

  // Future<void> update() async {
  //   await updateUser();
  //   await populatePostsForCurrentUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name),
              accountEmail: Text(widget.user.email),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 8, 133, 52),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Groups'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupsAddFrinds(
                      user: widget.user,
                    ),
                  ),
                );

                await updateUser();
                await populatePostsForCurrentUser();
                setState(() {});
              },
            ),

            ListTile(
              leading: const Icon(Icons.connect_without_contact_sharp),
              title: const Text('Make conections'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddFriends(
                              user: widget.user,
                            )))
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.edit),
            //   title: const Text('My profile Eddit'),
            //   onTap: () => {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (_) => ProfilePage(user: user)))
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.security),
            //   title: const Text('Security'),
            //   onTap: () => {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (_) => const ChangePaswordPage()))
            //   },
            // ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoggingPage(title: "Logging page"),
                    ))
              },
            ),
          ],
        ),
      ),
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
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            user: widget.user,
                          )));
              await populatePostsForCurrentUser();
              setState(() {});
            },
          ),
        ],
      ),
      body: posts.isEmpty // await populatePostsForCurrentUser();
          ? const Center(child: CircularProgressIndicator())
          : PostListWidget(
              posts: posts,
              user: widget.user,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {});

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => NewPostPage(
                        user: widget.user,
                      )));
          //await update();  even thow it contains it does not work
          await updateUser();
          await populatePostsForCurrentUser();
          setState(() {}); // Trigger a rebuild of the MainPage
        },
        tooltip: "make post",
        child: const Icon(Icons.add),
      ),

      //backgroundColor: const Color.fromARGB(255, 49, 49, 49)
    );
  }

  // Future<void> populateUsersFromFriends() async {
  //   final List<User> userList = [];
  //   for (final friendEmail in widget.user.friends) {
  //     final userData = await getUserDataByEmail(friendEmail);
  //     if (userData == null) {
  //       return;
  //     }
  //     final user = User.fromJson(userData);
  //     userList.add(user);
  //   }
  //   setState(() {
  //     users = userList;
  //   });
  // }

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

  Future<bool> updateUser() async {
    final email = widget.user.email;
    final pass = widget.user.password;
    var client = http.Client();
    const url = 'http://localhost:8080/api/friends/user';
    final uri = Uri.parse(url).replace(queryParameters: {
      'UserEmail': email,
      'UserPassword': pass,
    });
    final response = await client.get(uri);
    final body = response.body;
    if (body.isNotEmpty && response.statusCode == 200) {
      final json = jsonDecode(body);
      setState(() {
        widget.user = User.fromJson(json);
        widget.user.password = pass;
        populatePostsForCurrentUser();
      });
      return true;
    } else {
      return false;
    }
  }
}
