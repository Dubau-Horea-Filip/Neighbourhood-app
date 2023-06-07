import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborhood_app/Pages/new_comm_page.dart';
import 'dart:convert';
import '../Model/User.dart';
import '../api.dart';
import '../Model/Comment.dart';
import '../Model/Post.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final User user;

  const PostWidget({Key? key, required this.post, required this.user})
      : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments(widget.post.postId);
  }

  Future<void> fetchComments(String postId) async {
    const url = '${apiBaseUrl}api/comment/comments';
    final uri = Uri.parse(url).replace(queryParameters: {'postId': postId});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      List<Comment> fetchedComments = [];
      for (var commentJson in parsedJson) {
        Comment comment = Comment.fromJson(commentJson);
        fetchedComments.add(comment);
      }

      setState(() {
        comments = fetchedComments;
      });
    } else {
      throw Exception('Failed to fetch comments');
    }

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  widget.post.group,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  widget.post.post_content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await navigateToNewCommentPage();
              },
              icon: Icon(Icons.comment),
            ),
          ],
        ),
        (comments.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final bool isCurrentUserComment =
                      comment.user_email == widget.user.email;

                  return ListTile(
                    title: GestureDetector(
                      onLongPress: () {
                        if (isCurrentUserComment) {
                          showDeleteCommentDialog(comment);
                        }
                      },
                      child: Text(
                        comment.comment,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "User: ${comment.user_email}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Future<void> navigateToNewCommentPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewCommPage(
          user: widget.user,
          postId: widget.post.postId,
        ),
      ),
    );

    // Refresh comments after returning from the NewCommPage
    await fetchComments(widget.post.postId);
  }

  Future<void> showDeleteCommentDialog(Comment comment) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteComment(comment);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteComment(Comment comment) async {
    // Make an API call to delete the comment using comment.commentId or any relevant identifier
    // Example: Send an HTTP DELETE request to the API endpoint with comment.commentId

    // Refresh comments after deleting the comment
    await fetchComments(widget.post.postId);
  }
}
