// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:neighborhood_app/new/widgets/appbar.dart';
import 'package:neighborhood_app/new/widgets/profile_pic.dart';

import '../Model/User.dart';
import 'edditing_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //String url = "https://drive.google.com/file/d/1vvBmvbkP18v_ulczAWJ8io7FfTppc20N/view";
  String url =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            //imagePath: widget.user.pictureurl,
            imagePath: url,
            onClicked: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: widget.user)),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(widget.user),
          //const SizedBox(height: 24),
          // Center(child: buildUpgradeButton()),
          //const SizedBox(height: 24),

          const SizedBox(height: 48),
          buildAbout(widget.user),
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

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'Upgrade To PRO',
  //       onClicked: () {},
  //     );

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
              user.name,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
