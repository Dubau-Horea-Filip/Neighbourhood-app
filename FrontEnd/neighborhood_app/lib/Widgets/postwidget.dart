import 'package:flutter/material.dart';

import '../Model/Post.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;

  const PostListWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post.post_content),
          subtitle: Text(post.group),
          // Add any additional UI components for the post here
        );
      },
    );
  }
}
