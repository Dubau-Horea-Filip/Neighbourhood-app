import 'package:flutter/material.dart';
import 'package:neighborhood_app/new/widgets/appbar.dart';
import 'package:neighborhood_app/new/widgets/profile_pic.dart';
import 'package:neighborhood_app/new/widgets/textfield_widget.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import '../Model/User.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
            TextFieldWidget(
              label: 'Full Name',
              text: widget.user.name,
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: widget.user.email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'About',
              text: widget.user.about,
              maxLines: 5,
              onChanged: (about) {},
            ),
          ],
        ),
      );
}
