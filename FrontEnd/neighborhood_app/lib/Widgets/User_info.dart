// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../Model/User.dart';


class UserInformationWidget extends StatelessWidget {
  final User user;

  const UserInformationWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${user.name}'),
        Text('Email: ${user.email}'),
        //Text('Friends: ${user.friends.join(", ")}'),
        Text('Groups: ${user.groups.join(", ")}'),
      ],
    );
  }
}
