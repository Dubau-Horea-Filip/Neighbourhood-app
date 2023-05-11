import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 104, 26, 26),
          title: const Text("Profile"),
        ),
        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Text("profile"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                initialValue: "John",
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                initialValue: "Doe",
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Start Date',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                initialValue: "21",
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Age',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                initialValue: "82",
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Weight',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                initialValue:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Motivational Quote',
                ),
              ),
            ),
          ],
        ));
  }
}