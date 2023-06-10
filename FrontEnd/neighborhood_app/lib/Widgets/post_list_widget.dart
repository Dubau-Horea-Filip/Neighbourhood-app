import 'package:flutter/material.dart';
import 'package:neighborhood_app/Widgets/post_widget.dart';
import '../Model/Post.dart';
import '../Model/User.dart';

class PostListWidget extends StatefulWidget {
  final List<Post> posts;
  final User user;

  const PostListWidget({Key? key, required this.posts, required this.user})
      : super(key: key);

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  List<String> availableGroups = [];
  List<String> selectedGroups = [];

  @override
  void initState() {
    super.initState();
    getSelectedGroups();
  }

  void getSelectedGroups() {
    for (var post in widget.posts) {
      if (!availableGroups.contains(post.group)) {
        availableGroups.add(post.group);
      }
    }
  }

  List<Post> getFilteredPosts() {
    if (selectedGroups.isEmpty) {
      // Return all posts if no groups are selected
      return widget.posts;
    } else {
      // Filter posts based on selected groups
      return widget.posts
          .where((post) => selectedGroups.contains(post.group))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = getFilteredPosts();

    return Column(
      children: [
        Wrap(
          children: availableGroups
              .map(
                (group) => CheckboxListTile(
                  title: Text(group),
                  value: selectedGroups.contains(group),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedGroups.add(group);
                      } else {
                        selectedGroups.remove(group);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return PostWidget(
                post: post,
                user: widget.user,
              );
            },
          ),
        ),
      ],
    );
  }
}
