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
                  widget.post.post_content,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                subtitle: Text(
                  "Group: ${widget.post.group}\nUser: ${widget.post.email}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await navigateToNewCommentPage();
              },
              icon: const Icon(Icons.comment),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            final bool isCurrentUserComment =
                comment.user_email == widget.user.email;

            return ListTile(
              onLongPress: () {
                if (isCurrentUserComment) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Comment'),
                      content: const Text(
                          'Are you sure you want to delete this comment?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteComment(comment);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }
              },
              tileColor: Color.fromARGB(76, 9, 83, 16),
              title: Row(
                children: [
                  Text(
                    comment.comment,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "User: ${comment.user_email}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
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

  // Future<void> showDeleteCommentDialog(Comment comment) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Delete Comment'),
  //         content:const  Text('Are you sure you want to delete this comment?'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Delete'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               deleteComment(comment);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> deleteComment(Comment comment) async {
    const url = '${apiBaseUrl}api/comment/remove-comment';
    final id = comment.id;

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'id': id});

    final request = http.Request('DELETE', Uri.parse(url));
    request.headers.addAll(headers);
    request.body = body;

    final response = await request.send();

    if (response.statusCode == 200) {
      // Comment deleted successfully
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text('Comment deleted successfully.'),
        ),
      );

      // Refresh comments after deleting
      await fetchComments(widget.post.postId);
    } else {
      // Failed to delete comment
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text('Failed to delete comment.'),
        ),
      );
    }
  }
}
