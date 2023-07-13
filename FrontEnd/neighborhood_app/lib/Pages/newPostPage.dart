import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborhood_app/Widgets/text_box.dart';
import '../Model/User.dart';
import '../Widgets/button.dart';
import '../Widgets/dropdown.dart';

class NewPostPage extends StatefulWidget {
  final User user;

  const NewPostPage({required this.user, Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late TextEditingController groupController;
  late TextEditingController postContentController;

  @override
  void initState() {
    super.initState();
    groupController = TextEditingController();
    postContentController = TextEditingController();
  }

  @override
  void dispose() {
    groupController.dispose();
    postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownWidget(
              label: 'Select a group',
              items: widget.user.groups,
              onChanged: (selectedItem) {
                // Handle the selected item here
                groupController.text = selectedItem;
                //print('Selected item: $selectedItem');
              },
            ),
            TextBox(postContentController, "post content"),

            // TextFieldWidgetController(
            //   controller: groupController,
            //   label: 'Group',
            //   isVisible: true,
            // ),
            // const SizedBox(height: 16.0),
            // TextFieldWidgetController(
            //   controller: postContentController,
            //   label: 'Post Content',
            //   isVisible: true,
            // ),
            const SizedBox(height: 26.0),
            ButtonWidget(
              onClicked: () async {
                // Perform the post action here
                final String group = groupController.text;
                final String postContent = postContentController.text;

                if (group.isNotEmpty && postContent.isNotEmpty) {
                  // Make the API call or perform the desired action
                  bool ok = createPost(group, postContent) as bool;
                  if (ok) {
                    Navigator.pop(context);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      content: Text('Please fill in all the fields.'),
                    ),
                  );
                }
              },
              text: 'Post',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> createPost(String group, String postContent) async {
    const url = 'http://localhost:8080/api/post';
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = json.encode(<String, String>{
      'group': group,
      'post': postContent,
      'email': widget.user.email,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // Post created successfully
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content:
              Text('Post created successfully.\n\nResponse: ${response.body}'),
        ),
      );

      // Clear the text fields
      groupController.clear();
      postContentController.clear();

      // You can perform additional actions or navigate to a different page if needed
      return true;
    } else {
      // Post creation failed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Failed to create post.\n\nResponse: ${response.body}'),
        ),
      );
      return false;
    }
  }
}
