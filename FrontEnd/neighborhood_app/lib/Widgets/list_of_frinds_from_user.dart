import 'package:flutter/material.dart';

import '../Model/User.dart';
import 'User_info.dart';

class UserListWidget extends StatelessWidget {
  final List<User> users;

  const UserListWidget({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return UserInformationWidget(user: users[index]);
      },
    );
  }
}
