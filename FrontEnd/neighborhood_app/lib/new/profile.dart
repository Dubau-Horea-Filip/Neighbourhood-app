// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborhood_app/new/widgets/appbar.dart';
import 'package:neighborhood_app/new/widgets/profile_pic.dart';
import 'package:http/http.dart' as http;
import '../Model/Post.dart';
import '../Model/User.dart';
import 'edditing_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User useru;
  String url =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  List<Post> userPosts = [];
  @override
  void initState() {
    useru = widget.user;
    updateUser();
    super.initState();
    fetchUserPosts();
  }

  Future<void> fetchUserPosts() async {
    try {
      List<Post> posts = await getUserPosts();
      setState(() {
        userPosts = posts;
      });
    } catch (error) {
      print('Failed to retrieve user posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: url,
            onClicked: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: useru),
                ),
              );
              await updateUser();
            },
          ),
          const SizedBox(height: 24),
          buildName(useru),
          const SizedBox(height: 48),
          buildAbout(useru),
          const SizedBox(height: 48),
          buildPosts(),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildPosts() {
    // Retrieve the posts made by the user

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Posts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            final post = userPosts[index];

            return ListTile(
              title: Text(post.post_content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     // Handle edit post action
                  //     editPost(post);
                  //   },
                  //   icon: const Icon(Icons.edit),
                  // ),
                  IconButton(
                    onPressed: () {
                      // Handle delete post action
                      deletePost(post);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<List<Post>> getUserPosts() async {
    const url = 'http://localhost:8080/api/post/posts_user';
    // final body = json.encode(<String, String>{
    //   'email': widget.user.email,
    // });
    final response = await http.get(
        Uri.parse(url).replace(queryParameters: {'email': widget.user.email}));

    if (response.statusCode == 200) {
      final List<dynamic> parsedJson = json.decode(response.body);
      final List<Post> posts =
          parsedJson.map((json) => Post.fromJson(json)).toList();
      return posts;
    } else {
      throw Exception('Failed to retrieve user posts.');
    }
  }

  void editPost(Post post) {
    // Implement your logic to handle the edit post action
    // You can navigate to an edit post screen and pass the post object
    // to edit the content of the post
  }

  Future<void> deletePost(Post post) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    var url = 'http://localhost:8080/api/post/remove-post';
    final body = json.encode(<String, String>{
      'group': post.group,
      'post': post.post_content,
      'email': widget.user.email,
    });

    try {
      final response =
          await http.delete(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Post deleted successfully
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
                'Post deleted successfully.\n\nResponse: ${response.body}'),
          ),
        );
      } else if (response.statusCode == 404) {
        // Post not found
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text('Post not found.\n\nResponse: ${response.body}'),
          ),
        );
      } else {
        // Other error occurred
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content:
                Text('Failed to delete post.\n\nResponse: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      // Network request failed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Failed to delete post. Error: $e'),
        ),
      );
    }
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
        useru = User.fromJson(json);
        useru.password = pass;
      });
      return true;
    } else {
      return false;
    }
  }
}
