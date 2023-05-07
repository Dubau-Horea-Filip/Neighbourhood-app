
import 'package:flutter/material.dart';
import 'package:neighborhood_app/Pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     // drawer:  NavBar( plansid: plansid),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: const Text("Home Page"),
        actions: [
          IconButton(
            splashRadius: 25,
            icon: const CircleAvatar(
              minRadius: 25,
              // foregroundImage: Image.asset(
              //   'assets/Krunal.jpg',
              // ),
              // backgroundImage: Image.asset('assets/profile.png'),
              child: Text("profile"),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Profile()));
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49)
    );
    
  }
}