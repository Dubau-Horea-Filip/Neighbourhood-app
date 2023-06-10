import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborhood_app/Widgets/button.dart';
import 'package:neighborhood_app/new/widgets/appbar.dart';
import 'package:neighborhood_app/new/widgets/profile_pic.dart';
import 'package:neighborhood_app/new/widgets/textfield_widget.dart';
import 'package:http/http.dart' as http;
import '../Model/User.dart';
import '../Widgets/textfield_widget.dart';
import '../api.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController controllerName;
  late TextEditingController controllerAbout;

  @override
  void initState() {
    controllerName = TextEditingController();
    controllerName.text = widget.user.name;
    controllerAbout = TextEditingController();
    controllerAbout.text = widget.user.about;
    // getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: widget.user.pictureurl,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidgetController(
              label: 'Full Name',
              isVisible: true,
              controller: controllerName,
            ),
            const SizedBox(height: 24),
            TextFieldWidgetController(
              label: 'About',
              isVisible: true,
              controller: controllerAbout,
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              onClicked: () async {
                String name = controllerName.text;
                String about = controllerAbout.text;
                if (name.isNotEmpty && about.isNotEmpty) {
                  String result = await updateUser(controllerName.text,
                      widget.user.email, controllerAbout.text);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(result),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      content: Text("All fields should be filled"),
                    ),
                  );
                }
              },
              text: 'Update',
            )
          ],
        ),
      );

  Future<String> updateUser(String name, String email, String about) async {
    const String url = '${apiBaseUrl}api/friends/update';

    final uri = Uri.parse(url).replace(queryParameters: {
      'UserEmail': email,
      'UserAbout': about,
      'UserDisplayName': name
    });

    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.put(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Update failed. Error: ${response.body}";
    }
  }
}
