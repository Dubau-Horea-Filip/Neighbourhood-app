import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/User.dart';
import '../Widgets/button.dart';
import '../Widgets/textfield_widget.dart';
import '../api.dart';

class NewCommPage extends StatefulWidget {
  final User user;
  final String postId;

  const NewCommPage({required this.user, required this.postId, Key? key})
      : super(key: key);

  @override
  _NewCommPageState createState() => _NewCommPageState();
}

class _NewCommPageState extends State<NewCommPage> {
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldWidgetController(
              controller: commentController,
              label: 'Comment',
            ),
            const SizedBox(height: 26.0),
            ButtonWidget(
              onClicked: () async {
                // Perform the comment action here
                final String comment = commentController.text;

                if (comment.isNotEmpty) {
                  // Make the API call or perform the desired action
                  bool ok = await makeComment(widget.postId, comment);
                  if (ok) {
                    Navigator.pop(context);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      content: Text('Please enter a comment.'),
                    ),
                  );
                }
              },
              text: 'Post Comment',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> makeComment(String postId, String comment) async {
    final String url = '${apiBaseUrl}api/comment/make-comm';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> requestBody = {
      'email': widget.user.email,
      'postId': postId,
      'comment': comment,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Comment made successfully
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content:
              Text('Comment made successfully.\n\nResponse: ${response.body}'),
        ),
      ).then((_) {
        // Clear the text field
        commentController.clear();
      });

      // You can perform additional actions or navigate to a different page if needed
      return true;
    } else {
      // Comment creation failed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content:
              Text('Failed to make comment.\n\nResponse: ${response.body}'),
        ),
      );
      return false;
    }
  }
}
