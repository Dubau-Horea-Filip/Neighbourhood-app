import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Group.dart';
import '../Model/User.dart';

class AddGroupsAddFrinds extends StatefulWidget {
  final User user;
  const AddGroupsAddFrinds({Key? key, required this.user});

  @override
  State<AddGroupsAddFrinds> createState() => _AddGroupsAddFrindsState();
}

class _AddGroupsAddFrindsState extends State<AddGroupsAddFrinds> {
  late List<Group> potentialGroups = [];
  late List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    getPotentialGroups(widget.user.email);
    getUserGroups(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make connections"),
      ),
      body: ListView.separated(
        itemCount: potentialGroups.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final group = potentialGroups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('Common Friends: ${group.numberOfCommonFriends}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle join group button tap
                joinGroup(group);
              },
              child: Text("Join Group"),
            ),
          );
        },
      ),
    );
  }

  void getPotentialGroups(String email) async {
    const url = 'http://localhost:8080/api/group/potential-groups';
    final uri = Uri.parse(url).replace(queryParameters: {'userEmail': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Group> groups = [];

      for (var groupData in responseData) {
        Group group = Group(
          name: groupData['groupName'] ?? '',
          location: groupData['location'] ?? '',
          numberOfCommonFriends: groupData['numCommonFriends'] ?? 0,
        );
        groups.add(group);
      }

      setState(() {
        potentialGroups = groups;
      });
    } else {
      throw Exception('Failed to load potential groups');
    }
  }

  void joinGroup(Group group) async {
    const url = 'http://localhost:8080/api/group/add-membership';
    final parameters = {
      'groupName': group.name,
      'userEmail': widget.user.email,
    };

    final response = await http.post(Uri.parse(url), body: parameters);

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Group Joined"),
          content:
              Text("You have successfully joined the group: ${group.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to join the group: ${group.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void getUserGroups(String email) async {
    const url = 'http://localhost:8080/api/group/user-groups';
    final uri = Uri.parse(url).replace(queryParameters: {'userEmail': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Group> groups = [];

      for (var groupData in responseData) {
        Group group = Group(
          name: groupData['groupName'] ?? '',
          location: groupData['location'] ?? '',
          numberOfCommonFriends: groupData['numCommonFriends'] ?? 0,
        );
        groups.add(group);
      }

      setState(() {
        this.groups = groups;
      });
    } else {
      throw Exception('Failed to load user groups');
    }
  }
}
