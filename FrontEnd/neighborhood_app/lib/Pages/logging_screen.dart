import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborhood_app/Pages/main_page.dart';
import 'package:neighborhood_app/Pages/sign_in_page.dart';
import 'package:neighborhood_app/Widgets/text_box.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {

  var userid;
  var email = "";
  var friends = [];
  var password = "";

  late TextEditingController controllerName;
  late TextEditingController controllerPassword;

  @override
  void initState() {
    controllerName = TextEditingController();
    controllerPassword = TextEditingController();
   // getUserInfo();
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: Text(widget.title),
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      body: Center(
        child: ListView(
          children: [
            TextBox(controllerName, "Name"),
            TextBox(controllerPassword, "password"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MyWidget()));
                  },
                  child: const Text("Sign Up")),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {
                    String name = controllerName.text;
                    String pass = controllerPassword.text;
                    if (name.isNotEmpty && pass.isNotEmpty) {
                      if (checkCredentials(name, pass)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>  MainPage()));  //(userid: userid, email: email, workoutPlansId: plansid)));
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                  //title: Text("opa"),
                                  content: Text("Invalid Credentials"),
                                ));
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                //title: Text("opa"),
                                content: Text("All filds shoud be filled"),
                              ));
                    }
                  },
                  child: const Text("Login")),
            )
          ],
        ),
      ),
    );
  }

   bool checkCredentials(name, pass) {
    
   
  }

  login(name, pass) {}

  empty() {}

  Future<void> getUserInfo() async {
    var client = http.Client();
    const url = 'http://10.0.2.2:8080/user/current'; // user info
    //const url = 'http://192.168.110.1:8080/user/current';
    //const url = 'http://192.168.1.102:8080/user/current'; // fasole ip
    // "id": 0,
    //     "email": "testuser@gmail.com",
    //     "workoutPlans": [
    //         3
    //     ]
    final uri = Uri.parse(url);
    final response = await client.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    setState(() {
      userid = json['id'];
      email = json['email'];
      password = json['password'];
    });
  }
}
