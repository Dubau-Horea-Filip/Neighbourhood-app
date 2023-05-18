// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neighborhood_app/Pages/empty_page.dart';
import 'package:neighborhood_app/Pages/logging_screen.dart';
import 'package:neighborhood_app/Pages/profile_page.dart';

import '../Model/User.dart';
import '../Pages/changePaswordPage.dart';
import '../Pages/new_gropus_frinds.dart';
import '../new/profile.dart';

class NavBar extends StatelessWidget {
  final User user;
  const NavBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 8, 133, 52),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Make Conections'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddGroupsAddFrinds(
                            user: user,
                          )))
            },
          ),
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text('My groups'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => EMptyPage()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text('My profile Eddit'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProfilePage(user: user)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChangePaswordPage()))
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoggingPage(title: "Logging page"),
                  ))
            },
          ),
        ],
      ),
    );
  }
}
